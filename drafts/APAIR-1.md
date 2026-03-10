---
title: "APAIR-1 — Account Pairing Protocol"
author: "Shelly"
status: draft
created: 2026-03-10
---

# APAIR-1 — Account Pairing Protocol

Status: Draft  
Author: Shelly  
Version: 1

---

## Abstract

APAIR-1 defines a lightweight protocol for pairing a controller wallet with a bot or service account on Algorand-compatible networks such as Algorand and Voi. Pairing is established through a deterministic native-token payment transaction containing an ARC-2 formatted note.

The sender of the first valid pairing transaction becomes the paired controller of the receiving account. This pairing event acts as the trust anchor for automated policy updates and account management by systems such as Wallet MCP.

---

## Motivation

Bots, service accounts, and autonomous agents often require a controller wallet responsible for configuration, policy management, and operational authority.

Traditional solutions rely on:

- smart contracts
- centralized registries
- off-chain configuration

APAIR-1 instead provides a deterministic bootstrap mechanism that:

- establishes account ownership
- enables automatic discovery of managed accounts
- creates an auditable on-chain pairing event
- requires no smart contracts or additional infrastructure

The pairing transaction serves simultaneously as:

1. Authorization
2. Initialization
3. Discovery signal

---

## Terminology

**Controller**

The wallet that initiates the pairing transaction and becomes the authority over the paired account.

**Bot Account**

The account being paired and controlled by the controller.

**Pairing Transaction**

A native payment transaction that satisfies the APAIR-1 validation rules.

---

## Protocol Overview

A bot account becomes paired when it receives its **first inbound transaction** and that transaction satisfies the APAIR-1 pairing rules.

If any transaction occurs before a valid pairing transaction, the account is no longer eligible for pairing.

The sender of the pairing transaction becomes the paired controller.

---

## Pairing Transaction Requirements

A transaction qualifies as an APAIR-1 pairing transaction if:

1. Transaction type is **Payment**
2. Asset is the **network native token**
3. Amount equals **1,000,000 micro-units** (1 ALGO or 1 VOI)
4. Receiver is the target bot account
5. Transaction note contains a valid APAIR protocol payload
6. The transaction is the **first inbound transaction received by the account**

---

## ARC-2 Note Format

APAIR-1 uses the ARC-2 note convention.

`apair:u<data>`

Where `u` indicates UTF-8 encoded data.

---

## Payload Format

`1|pair|<network>|<definition_address>`

Fields:

| Field | Description |
|------|-------------|
| 1 | protocol version |
| pair | action |
| network | network identifier (`voi`, `algorand`) |
| definition_address | address defining the bot/agent policy |

---

## Example Notes

### Voi

`apair:u1|pair|voi|A7D4JH5S2K3L9F1P0Q8W6R4T3U2V1Y9Z8X7C6B5N4M3L2K1J0H9G8F`

### Algorand

`apair:u1|pair|algorand|B3F8L2J9M5P1Q4R6S7T0V8W2X3Y5Z6A1C9D8E7F4G2H3J5K7L8M0N`

---

## Validation

An implementation MUST validate:

- transaction type = payment
- amount = `1_000_000`
- note begins with `apair:u`
- payload matches `1|pair|...`
- transaction is the **first inbound transaction** to the receiver

If valid:

`paired_controller = transaction.sender`

---

## Pairing Result

A successful pairing establishes the relationship:

`controller → bot_account`  
`bot_account → definition_address`

Example record:

```
controller: WALLET_ADDR
bot_account: BOT_ADDR
definition: POLICY_ADDR
pair_txid: TXID
pair_round: ROUND
```

---

## Discovery

Systems may discover paired accounts by scanning transactions with notes beginning with:

`apair:u`

Valid transactions produce the derived registry:

| Bot | Controller | Definition |
|----|------------|-----------|
| BOT1 | WALLET1 | POLICY1 |
| BOT2 | WALLET1 | POLICY2 |

This enables a decentralized registry without requiring smart contracts.

---

## Definition Address

The `definition_address` identifies the configuration or policy describing the bot.

Possible uses include:

- policy definitions
- agent capability metadata
- resolver accounts
- service configuration records

Interpretation of this address is outside the scope of APAIR-1.

---

## Security Considerations

### Address Secrecy

Pairing assumes the bot address is initially known only to the intended controller.

### Deterministic Initialization

Strict first-transaction rules prevent race conditions after initialization.

### Auditability

Controller assignment is permanently verifiable through the pairing transaction.

---

## Implementation Guidance

Recommended flow:

1. Generate bot account
2. Share address with controller wallet
3. Controller sends pairing transaction
4. Pairing is detected
5. Bot becomes active

---

## Future Extensions

Potential future extensions include:

- controller rotation
- pairing revocation
- capability descriptors
- agent discovery integration
- hierarchical account graphs
