---
title: "ARES-1: AlgoSeas Royalty Enforcement System"
author: "Shelly"
status: draft
created: 2026-03-10
---

# ARES-1: AlgoSeas Royalty Enforcement System

## Abstract

The **AlgoSeas Royalty Enforcement System (ARES)** defines a metadata format and marketplace enforcement mechanism for distributing royalties to NFT creators on Algorand. The system encodes royalty distribution data within NFT metadata and enables marketplaces to enforce creator payouts during secondary sales while maintaining compatibility with existing NFT standards.

ARES intentionally implements **soft enforcement**, allowing NFTs to remain transferable like standard Algorand assets while enabling compliant marketplaces to enforce royalty payouts automatically.

---

## Motivation

NFT creators often rely on secondary-sale royalties to sustain their work. However, strict on-chain enforcement mechanisms can introduce compatibility issues or prevent NFTs from functioning like standard assets.

The AlgoSeas system seeks to balance these concerns by:

- Allowing **standard Algorand transfers** without restriction
- Enabling **marketplaces to enforce royalties** during sales
- Supporting **existing NFT standards such as ARC-3 and ARC-69**
- Allowing flexible **multi-recipient royalty distribution**

This approach ensures that creators can receive royalties while preserving the composability and portability of Algorand NFTs.

---

## Specification

### Royalty Metadata Field

NFT metadata may include a property named:

`royalties`

The value of this property is a **base64-encoded binary payload** that defines royalty configuration.

---

### Royalty Payload Format

The decoded payload MUST be **104 bytes** in length.

| Bytes | Field |
|------|------|
| 0-1 | Royalty Points |
| 2-3 | Creator1 Points |
| 4-5 | Creator2 Points |
| 6-7 | Creator3 Points |
| 8-39 | Creator1 Address |
| 40-71 | Creator2 Address |
| 72-103 | Creator3 Address |

Points fields represent **basis points (bps)**.

- Range: **0–10,000**
- 10,000 = 100%

Creator share fields MUST sum to **10,000**.

Royalty Points represent the **total royalty percentage applied to the sale price**.

Creator share fields determine how that royalty amount is distributed among creators.

Addresses are standard **Algorand 32-byte addresses**.

Unused addresses MUST be set to the **zero address**.

---

### Royalty Calculation

Given:

```
sale_price
royalty_points
```

Royalty amount is calculated as:

```
royalty_amount = sale_price * royalty_points / 10,000
```

Distribution to creators:

```
creator_share = royalty_amount * creator_points / 10,000
```

---

## Marketplace Enforcement

Marketplaces implementing ARES SHOULD:

1. Read the `royalties` metadata field from the NFT.
2. Decode and validate the royalty payload.
3. Insert royalty configuration into the marketplace sale contract.
4. Enforce payouts during settlement.

If a listing includes royalty data that does not match the NFT metadata, the marketplace SHOULD treat the listing as invalid and hide it from users.

---

## Sale Settlement

When an NFT sale is finalized:

1. The seller claims the sale proceeds.
2. The royalty portion is automatically distributed to creators.
3. Remaining funds are sent to the seller.

Up to **four accounts** may receive payouts:

- Seller
- Creator1
- Creator2
- Creator3

This limit aligns with Algorand's foreign account constraints in transaction groups.

---

## Transaction Fees

Creators pay transaction fees from their royalty payout.

If a creator's payout is less than the minimum transaction fee, the payout MAY be skipped.

This ensures the system remains self-sustaining without requiring additional funding.

---

## Design Rationale

### Soft Enforcement

ARES deliberately avoids strict transfer restrictions.

Advantages:

- NFTs remain standard Algorand assets
- Compatibility with wallets and tooling
- No forced transfer restrictions
- Backward compatibility with ARC-3 and ARC-69 NFTs

### Multi-Recipient Royalties

Supporting three creator addresses allows typical NFT project distributions such as:

- Artist
- Developer
- Community treasury

Additional recipients may be handled by assigning one address to a smart contract that distributes funds further.

---

## Security Considerations

### Metadata Integrity

Marketplaces must verify royalty metadata before enforcing payouts.

Incorrect metadata supplied by malicious actors should cause listings to be rejected.

### Frontend Validation

Marketplaces should validate royalty payloads to ensure:

- Payload size is correct
- Creator shares sum to 10,000
- Addresses are valid

---

## Backwards Compatibility

ARES is compatible with existing Algorand NFT standards:

- ARC-3
- ARC-69

NFTs that do not include the `royalties` metadata field are treated as having **no royalties**.

---

## Reference Implementation

The reference implementation is the **AlgoSeas NFT marketplace royalty enforcement mechanism**.

Implementations may include:

- Marketplace contract enforcement
- Frontend royalty validation
- Metadata parsing utilities

---

## Future Extensions

Potential extensions include:

- Dynamic royalty structures
- Royalty registries
- On-chain royalty verification contracts
- Cross-marketplace royalty discovery

---

## Conclusion

The AlgoSeas Royalty Enforcement System provides a simple and flexible way to support NFT creator royalties on Algorand while preserving asset portability and compatibility with existing NFT standards.

By using metadata-encoded royalty configuration and marketplace enforcement, ARES provides a practical balance between creator incentives and ecosystem composability.
