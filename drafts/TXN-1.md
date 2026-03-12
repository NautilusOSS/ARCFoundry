---
title: "TXN-1 — Transaction Builder Tool Naming Convention"
author: "Shelly"
status: draft
created: 2026-03-12
---

# TXN-1 — Transaction Builder Tool Naming Convention

Status: Draft  
Author: Shelly  
Version: 1

---

## Abstract

This proposal defines a naming convention for tools that construct blockchain transactions within agent operating systems, protocol service gateways, and developer tooling.

The convention introduces the `_txn` suffix to clearly designate **transaction builder tools** whose purpose is to generate **unsigned transaction payloads** or **atomic transaction groups** suitable for signing and submission.

This specification improves composability, discoverability, and safety for agent-driven blockchain interactions.

---

## Motivation

Modern blockchain systems increasingly interact with:

- AI agents
- service gateways
- programmable infrastructure
- developer automation tools

Without consistent naming conventions:

- transaction builders are hard to discover
- signing may be mixed with transaction construction
- broadcasting may occur unintentionally
- agent orchestration becomes unreliable

Agent operating systems such as **UluOS** expose many services and tools. A predictable naming scheme allows agents to safely construct transactions without triggering execution.

This proposal standardizes the `_txn` suffix to clearly indicate **transaction construction only**.

---

## Specification

### `_txn` Suffix Definition

Any tool whose primary purpose is to construct blockchain transactions MUST end with:

`_txn`

A `_txn` tool returns:

- one unsigned transaction
- a group of unsigned transactions
- a wallet-ready payload

A `_txn` tool MUST NOT:

- sign transactions
- broadcast transactions
- wait for confirmation
- mutate blockchain state

---

### Naming Format

Transaction builder tools SHOULD follow this structure:

`<service>_<action>_<target>_txn`

Where:

- **service** — protocol or namespace
- **action** — operation being performed
- **target** — resource being acted upon
- **txn** — indicates transaction construction

---

### Example Tool Names

- `humble_swap_exact_in_txn`
- `humble_add_liquidity_txn`
- `envoi_register_name_txn`
- `dorkfi_borrow_txn`
- `aramid_bridge_lock_txn`

---

### Action Vocabulary

Recommended verbs include:

| Verb | Description |
|------|-------------|
| create | instantiate a new resource |
| update | modify an existing resource |
| transfer | move an asset between accounts |
| swap | exchange one asset for another |
| deposit | supply assets to a protocol |
| withdraw | remove assets from a protocol |
| borrow | take a loan against collateral |
| repay | return borrowed assets |
| claim | collect earned rewards |
| stake | lock assets for participation |
| unstake | release staked assets |
| mint | create new tokens |
| burn | destroy tokens |
| lock | time-lock or escrow assets |
| unlock | release locked assets |

Protocols MAY extend this list.

---

### Transaction Groups

The `_txn` suffix MUST be used even when the tool returns multiple transactions.

Example:

`dorkfi_open_loan_txn`

This may return a grouped set of transactions but remains a single transaction builder tool.

---

### Tool Behavior Requirements

A `_txn` tool MUST be:

#### Deterministic

Given the same inputs, the tool MUST produce the same transaction payload.

#### Side-Effect Free

The tool MUST NOT modify blockchain state.

#### Wallet Compatible

Outputs MUST be compatible with wallet signing workflows.

---

## Related Tool Suffixes

This proposal recommends reserving additional suffixes for the broader tool lifecycle.

| Suffix | Purpose |
|--------|---------|
| `_quote` | simulation or pricing |
| `_params` | parameter discovery |
| `_txn` | transaction construction |
| `_sign` | signing |
| `_broadcast` | submission |
| `_status` | confirmation tracking |

Example flow:

```
humble_swap_quote
humble_swap_exact_in_txn
wallet_sign_txn
broadcast_send
```

---

## Example Implementations

### HumbleSwap

- `humble_swap_exact_in_txn`
- `humble_swap_exact_out_txn`
- `humble_add_liquidity_txn`
- `humble_remove_liquidity_txn`

### Envoi

- `envoi_register_name_txn`
- `envoi_renew_name_txn`
- `envoi_set_profile_txn`

### DorkFi

- `dorkfi_deposit_collateral_txn`
- `dorkfi_withdraw_collateral_txn`
- `dorkfi_borrow_txn`
- `dorkfi_repay_txn`

### Bridge Protocol

- `aramid_bridge_lock_txn`
- `aramid_bridge_redeem_txn`

---

## Rationale

Separating transaction construction from signing and broadcasting:

- improves safety by preventing unintended blockchain mutations
- improves composability by enabling transaction inspection and modification before execution
- simplifies agent orchestration by providing a predictable, discoverable interface

Agents can safely construct transactions without executing them.

---

## Security Considerations

Transaction construction MUST remain deterministic and side-effect free.

Separating transaction construction from execution prevents unintended blockchain mutations. A `_txn` tool that violates the side-effect-free requirement could allow malicious or buggy implementations to trigger state changes during what callers expect to be a read-only operation.

Implementations SHOULD validate all inputs before constructing transactions to prevent malformed payloads from reaching signing workflows.

---

## Future Extensions

Possible future extensions include:

- standardized transaction payload schemas
- multi-chain transaction builders
- wallet compatibility layers
- agent-safe execution pipelines
- formal verification of `_txn` tool compliance
