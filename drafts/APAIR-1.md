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

## Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

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

A **first inbound transaction** is defined as the first payment transaction received by the account on a given network. Only standalone transactions (group size of 1) with the exact pairing amount qualify. Zero-amount payments, asset transfers, inner transactions from application calls, rekey transactions, and any transaction that is part of a group do not qualify and, if received before a valid pairing transaction, permanently disqualify the account from pairing on that network.

If any non-qualifying transaction is received before a valid pairing transaction, the account is no longer eligible for pairing on that network.

The sender of the pairing transaction becomes the paired controller.

### Cross-Network Pairing

APAIR-1 supports pairing on both Voi and Algorand. When the same bot account address exists on multiple networks, the first valid pairing transaction on each network independently establishes pairing for that network.

The first pairing transaction across all networks becomes the **primary authority**. However, if the bot account has received any inbound transaction on a given network before a valid pairing transaction arrives on that network, the account is permanently ineligible for pairing on that network.

Only mainnet networks (`voi`, `algorand`) are considered for production pairing. Testnet pairings are isolated and MUST NOT be treated as valid on mainnet.

---

## Pairing Transaction Requirements

A transaction qualifies as an APAIR-1 pairing transaction if:

1. Transaction type is **Payment**
2. Asset is the **network native token**
3. Amount equals **1,000,000 micro-units** (1 ALGO or 1 VOI)
4. Transaction group size is **1** (standalone, not part of a group)
5. Receiver is the target bot account
6. Transaction note contains a valid APAIR protocol payload
7. The transaction is the **first inbound transaction received by the account** on that network

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
| network | network identifier (`voi`, `algorand`, `voi-testnet`, `algorand-testnet`) |
| definition_address | address defining the bot/agent policy (REQUIRED) |

---

## Example Notes

### Voi

`apair:u1|pair|voi|A7D4JH5S2K3L9F1P0Q8W6R4T3U2V1Y9Z8X7C6B5N4M3L2K1J0H9G8FA7D4JH5S2K3L9F1P0`

### Algorand

`apair:u1|pair|algorand|B3F8L2J9M5P1Q4R6S7T0V8W2X3Y5Z6A1C9D8E7F4G2H3J5K7L8M0NB3F8L2J9M5P1Q4R6S7`

### Zero Address

The zero address (`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAY5HFKQ`) MUST NOT be used as a `definition_address`.

---

## Validation

An implementation MUST validate:

- transaction type = payment
- amount = `1_000_000`
- transaction group size = 1
- note begins with `apair:u`
- payload matches `1|pair|<network>|<definition_address>`
- `network` field matches the network the transaction was submitted on
- `definition_address` is a valid non-zero address
- transaction is the **first inbound transaction** to the receiver on that network

If valid:

`paired_controller = transaction.sender`

---

## Rejection Rules

An implementation MUST reject a pairing transaction if any of the following are true:

- Transaction type is not payment
- Amount is not exactly `1_000_000` micro-units
- Transaction is part of a group (group size > 1)
- Note is missing or does not begin with `apair:u`
- Payload is malformed (missing fields, unrecognized version, invalid action)
- `network` field does not match the network the transaction was submitted on
- `definition_address` is the zero address or an invalid address
- The receiver has already received any prior inbound transaction on that network

A rejected transaction MUST be ignored. If a non-qualifying transaction arrives before any valid pairing transaction, the account is permanently ineligible for pairing on that network.

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

### Scalability

For production implementations, scanning all on-chain transactions for `apair:u` notes is not practical at scale. Implementations SHOULD use network indexer APIs to query payment transactions by note prefix. Results SHOULD be cached locally and incrementally updated by tracking the last processed round. Maintaining a local pairing registry avoids redundant indexer queries and supports fast lookups.

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

## Backwards Compatibility

APAIR-1 uses only standard payment transactions and the existing ARC-2 note convention. It introduces no new transaction types, fields, or consensus requirements. It is fully compatible with all existing Algorand and Voi infrastructure, including wallets, explorers, and indexers.

APAIR-1 does not conflict with any existing ARC standards.

---

## Security Considerations

### Address Secrecy

Pairing assumes the bot address is initially known only to the intended controller.

### Front-Running

If the bot address leaks before pairing, a malicious actor could submit a valid pairing transaction first. In this case the account is permanently burned and cannot be recovered. The loss is bounded to the 1,000,000 micro-unit pairing amount. Implementations SHOULD generate the bot account and submit the pairing transaction in quick succession to minimize this window.

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
