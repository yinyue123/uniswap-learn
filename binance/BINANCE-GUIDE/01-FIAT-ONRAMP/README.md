# Fiat On/Off Ramp Complete Guide

## Overview
Converting traditional money (fiat) to crypto and back.

## Methods Comparison

| Method | Speed | Fees | Risk | Limits |
|--------|-------|------|------|--------|
| Bank Card | Instant | 1.8-2% | Low | $5k-50k/day |
| Bank Transfer | 1-3 days | 0-0.1% | Very Low | $50k-1M/day |
| P2P | 5-30 min | 0% | Medium-High | Flexible |
| Third Party | Instant | 2-4% | Low | Varies |

## 1. Direct Purchase (Card/Bank)

### How It Works
```
Your Bank → Payment Processor → Binance → Your Wallet
   ↓             ↓                ↓           ↓
  Fiat     Verification      Convert    Crypto
```

### Underlying Logic
- **Payment processors** (Simplex, Banxa) act as intermediaries
- They handle **KYC/AML compliance** for banks
- **Exchange rate** includes hidden spread (0.5-1%)

### Fees Breakdown
```
Total Cost = Amount + Processing Fee + Spread
Example: Buy $1000 USDT
- Processing: $20 (2%)
- Spread: $5 (0.5%)
- You get: ~975 USDT
```

### Risk Points
- **Card blocks**: Banks may flag as suspicious
- **Chargebacks**: Can freeze account
- **Failed transactions**: Money stuck 3-5 days

### Best Practices
1. Call bank first, notify of crypto purchase
2. Start small ($100) to test
3. Use debit not credit (lower fees)
4. Screenshot everything

## 2. P2P Trading

### How It Works
```
You ←→ P2P Platform ←→ Other User
 ↓         ↓              ↓
Fiat   Escrow Service   Crypto
```

### The Escrow System
1. Seller locks crypto in Binance escrow
2. Buyer sends fiat directly to seller's bank
3. Seller confirms receipt
4. Binance releases crypto to buyer

### Why P2P Exists
- **Regulatory arbitrage**: Bypasses restrictions
- **Better rates**: No middleman fees
- **Local payment methods**: WeChat, Alipay, etc.

### Risk Matrix

**HIGH RISK Behaviors**
- Trading with <95% completion rate users
- Rushing trades without verification
- Using business accounts
- Trading round numbers frequently
- Not checking merchant verification

**RED FLAGS in Counterparties**
- New account (<30 days)
- Low trade volume (<100 trades)
- Asking to cancel after payment
- Communication outside platform
- Unusual payment notes

### P2P Safety Protocol
```
1. VERIFY merchant badge & stats
2. CHECK price against market (±2% normal)
3. RECORD everything (video is best)
4. PAY exactly as instructed
5. MARK as paid immediately
6. WAIT for crypto release
7. MOVE crypto out after receive
```

### Appeal Process
If dispute occurs:
1. Don't panic, you have 72 hours
2. Gather: Payment proof, chat logs, screenshots
3. Submit appeal with clear timeline
4. Binance support usually sides with evidence

## 3. Bank Transfer (SWIFT/SEPA)

### Process Flow
```
Day 0: Initiate wire
Day 1-2: Bank processing
Day 3: Binance credits account
```

### Why Use This?
- **Lowest fees** for large amounts
- **Best rates** (no card premium)
- **Highest limits** ($1M+)
- **Paper trail** for taxes

### Requirements
- Enhanced verification (address proof)
- Bank account in your name
- Matching names (Bank ↔ Binance)

## 4. Off-Ramp (Crypto → Fiat)

### Tax Implications
```
Taxable Event = Sell Price - Buy Price
Capital Gains = Taxable Event × Tax Rate
```

Keep records of:
- Buy date & price
- Sell date & price
- Transaction fees
- Transfer history

### Withdrawal Methods

**Bank Wire**
- 1-5 days processing
- $25-50 fee typically
- Best for large amounts

**P2P Cash Out**
- Immediate
- 0% Binance fee
- Higher counterparty risk

**Debit Card** (where available)
- Instant
- 1-2% fee
- Limited amounts

## 5. Common Pitfalls & Solutions

### Frozen Bank Account
**Cause**: Suspicious activity flags
**Solution**:
1. Contact bank immediately
2. Provide crypto exchange documentation
3. Explain investment purpose
4. Consider crypto-friendly bank

### Failed Verification
**Causes**:
- Name mismatch
- Expired documents
- Poor photo quality
- VPN usage

**Fix**: Use original documents, clear photos, real IP

### P2P Scams

**Fake Payment Proof**
- Always check YOUR bank
- Don't trust screenshots
- Wait for actual deposit

**Triangulation Scam**
- Scammer uses stolen funds
- You receive dirty money
- Your account gets frozen
**Prevention**: Trade only with verified merchants

### Card Declined
**Reasons & Fixes**:
1. International transaction block → Enable in app
2. Gambling merchant code → Call bank to whitelist
3. Daily limit hit → Wait or increase limit
4. 3D Secure fail → Enable SMS verification

## Regional Considerations

### High-Restriction Regions
China, India, Turkey, Nigeria

**Workarounds**:
- P2P primary method
- Stablecoin corridors
- OTC desks for large amounts
- Crypto-friendly neighboring countries

### Banking Relationships
**Crypto-Friendly Banks**:
- Revolut, Wise (EU/UK)
- Silvergate, Signature (US)
- DBS (Singapore)

**Banks to Avoid**:
- HSBC (blocks often)
- Chase (account closures)
- Wells Fargo (high scrutiny)

## Mathematical Models

### True Cost Calculation
```
Effective Rate = (Fiat Spent / Crypto Received)
Hidden Cost % = ((Effective Rate / Market Rate) - 1) × 100

Example:
Market: 1 BTC = $50,000
You pay: $51,000 for 1 BTC
Hidden cost: 2%
```

### P2P Arbitrage
```
Profit = (P2P Sell Rate - P2P Buy Rate) × Volume - Transfer Fees
ROI = (Profit / Capital) × 100

Typical spreads: 0.5-2%
Volume needed: >$10k for worthwhile
```

## Emergency Procedures

### Money Stuck
1. Document everything
2. Contact support with transaction ID
3. File complaint with payment processor
4. Bank dispute as last resort

### Account Frozen
1. Don't create new account
2. Complete enhanced verification
3. Provide source of funds proof
4. Be patient (7-30 days typical)

### Scammed
1. Report to Binance immediately
2. File police report
3. Contact your bank
4. Document for taxes (loss deduction)

## Best Practices Summary

1. **Start small** - Test with $100 first
2. **Build history** - Regular small trades better than one large
3. **Document everything** - For taxes and disputes
4. **Use multiple methods** - Don't rely on one
5. **Know your limits** - Daily, monthly, yearly
6. **Verify twice** - Addresses, amounts, recipients
7. **Time trades** - Avoid weekends/holidays
8. **Have backup** - Multiple bank accounts/cards