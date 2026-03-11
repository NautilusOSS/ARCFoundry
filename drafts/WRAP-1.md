---
title: "WRAP-1: ARC200 Wrapper Standard (WNT200, WNNT200, SAW200)"
author: "Shelly"
status: draft
created: 2025-08-06
---

# WRAP-1: ARC200 Wrapper Standard (WNT200, WNNT200, SAW200)

Status: Draft
Author: Shelly
Version: 1
Requires: ARC-0002 (ARC4), ARC-0200, ARC-0073 (ARC73)

---

## Summary

This specification defines a unified interface for wrapping and unwrapping assets into ARC200-compatible tokens, enabling cross-standard token interaction across Algorand. It covers three related wrappers:

* **WNT200**: Wraps native network tokens (e.g. ALGO, VOI)
* **WNNT200**: Wraps Algorand Standard Assets (ASAs)
* **SAW200**: Enables reverse exchange of ARC200 tokens into mirrored ASAs

All wrappers implement a shared minimal interface supporting standardized deposits and withdrawals.

---

## Abstract

The Wrapper200 standard provides a minimal, ARC4-compliant interface for token wrappers that convert native assets or ASAs into ARC200 tokens and vice versa. It facilitates composability with ARC200 protocols while preserving a clear and consistent wrapper abstraction. Wrapper contracts operate on a fixed-supply model with no minting outside of validated deposit logic.

---

## Motivation

The majority of Algorand tokens exist as native tokens or ASAs, which are not compatible with ARC200-based smart contracts and DeFi protocols. This standard enables a clean and consistent way to wrap those assets into ARC200, and unwrap them back as needed, while also establishing a basis for exchange gateways like SAW200.

---

## Specification

### Interface Definition

All Wrapper200-compliant contracts MUST implement one of the following interface variants, depending on wrapper type:

```
// WNT200 and WNNT200
interface IWrapper200 {
  deposit(amount: UInt) returns (UInt256)
  withdraw(amount: UInt) returns (UInt256)
}

// SAW200
interface ISAW200 {
  deposit(amount: UInt64) returns (void)
  withdraw(amount: UInt64) returns (void)
}
```

* `deposit(amount)`
  * Wraps the specified amount of underlying asset into ARC200
  * Mints ARC200 tokens to the caller
  * Validates the deposit via atomic transfer
* `withdraw(amount)`
  * Burns the specified amount of ARC200 tokens
  * Transfers the equivalent amount of underlying asset back to the caller

These methods MUST follow ARC4 ABI conventions.

### Interface Detection

All implementations MUST support ARC-73:

```
supportsInterface(interfaceId: Bytes[4]) returns (Bool)
```

Each wrapper type MUST register a unique interface ID, computed as the XOR of the first 4 bytes of the SHA-512/256 hash of each function signature:

| Wrapper Type | Method Signatures | Interface ID |
|------|------|------|
| WNT200 / WNNT200 | `deposit(uint64)uint256`, `withdraw(uint64)uint256` | `0xe986be2c` |
| SAW200 | `deposit(uint64)void`, `withdraw(uint64)void` | `0xe6a6b555` |

These values MUST be returned by `supportsInterface` and may be used by indexers, wallets, and protocol factories to detect supported functionality.

---

## Wrapper Variants

### WNT200: Wrapped Network Token

* Wraps the native token of the chain into ARC200
* Example: VOI → wVOI (ARC200)
* Useful for enabling staking, governance, and DeFi participation

### WNNT200: Wrapped Non-Network Token

* Wraps Algorand Standard Assets (ASAs) into ARC200
* Example: aUSDC → waUSDC (ARC200)
* Used for liquidity integration, ARC200-based DEXs, farming

### SAW200: Standard Asset Wrapper (Reverse)

* Accepts ARC200 tokens and returns a mirrored ASA equivalent
* Useful for bridging ARC200 tokens back into ASA-native environments
* Forms the reverse leg of the ARC200 Exchange Extension

---

## Security Considerations

* All deposits MUST be validated via atomic group logic
* Wrapping MUST mint only after verifying the corresponding transfer
* Unwrapping MUST burn ARC200 before transferring underlying asset
* Contracts MUST NOT support arbitrary minting or withdrawal

---

## Rationale

This unified standard enables consistent integration of native and non-native assets into ARC200-based protocols. It supports asset abstraction and unlocks ARC200 tooling for legacy ASA assets and native tokens without creating new standards for each asset class.

---

## Backward Compatibility

This standard does not modify ARC200, ARC4, or ARC73. It builds upon them with a new optional extension interface.

---

## Reference Implementation

A reference implementation of each wrapper type will be maintained under the [OpenSubmarine](https://github.com/voi-network/open-submarine) repository:

* **WNT200**: Wraps native VOI tokens using ARC4 with atomic validation
* **WNNT200**: Wraps existing ASA assets like aUSDC into ARC200 format
* **SAW200**: Facilitates redemption of ARC200 into mirrored ASA equivalents

Each implementation will:

* Follow ARC4 ABI definitions
* Enforce atomic deposit and withdrawal flows
* Include test cases and ARC-73 interface ID registration

---

## Future Considerations

* Optional support for fee collection
* Factory contracts for dynamic wrapper creation
* Cross-chain wrapping extensions

---

## Copyright

This specification is licensed under the MIT License.
