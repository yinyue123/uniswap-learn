# Hyperliquid Complete Master Guide

## Quick Navigation

### Foundation
- [01 - HL Fundamentals](01-HL-FUNDAMENTALS/README.md) - L1 & order book basics
- [02 - Getting Started](02-GETTING-STARTED/README.md) - Onboarding & deposits

### Trading
- [03 - Perpetual Trading](03-PERPETUAL-TRADING/README.md) - Core perps trading
- [04 - Order Types](04-ORDER-TYPES/README.md) - All order types explained
- [07 - Risk & Liquidations](07-RISK-LIQUIDATIONS/README.md) - Risk management

### Yield & Strategies
- [05 - HLP Liquidity](05-HLP-LIQUIDITY/README.md) - Provide liquidity via HLP
- [06 - Vaults & Strategies](06-VAULTS-STRATEGIES/README.md) - Vault trading
- [08 - Points & Rewards](08-POINTS-REWARDS/README.md) - Points system

### Advanced
- [09 - Advanced Features](09-ADVANCED-FEATURES/README.md) - API, bots, analytics

## What Makes Hyperliquid Unique

### Key Differentiators
```
1. Own L1 blockchain (not on Ethereum)
2. Order book (not AMM)
3. No gas fees for trading
4. Sub-second execution
5. Up to 50x leverage
6. On-chain everything
7. Native vaults system
```

## Hyperliquid vs Others

| Feature | Hyperliquid | Binance | Uniswap | dYdX |
|---------|------------|---------|---------|------|
| Type | Order Book DEX | CEX | AMM DEX | Order Book DEX |
| Chain | Own L1 | N/A | Ethereum+ | StarkEx/Cosmos |
| Speed | <1 second | Instant | 12 seconds | 1-2 seconds |
| Leverage | 50x | 125x | Via lending | 20x |
| Gas Fees | None | None | $10-100 | Minimal |
| KYC | No | Yes | No | No |
| Liquidity | HLP Vault | Market Makers | LPs | Market Makers |

## Core Formulas

### P&L Calculation
```
P&L = (Exit Price - Entry Price) × Size × Direction
ROE% = P&L / Margin × 100
```

### Liquidation Price
```
Long: Liq Price = Entry × (1 - 1/Leverage + Maintenance Margin)
Short: Liq Price = Entry × (1 + 1/Leverage - Maintenance Margin)

Maintenance Margin: 0.3% - 1% (varies by asset)
```

### Funding Rate
```
Funding = Position Size × Mark Price × Funding Rate
Paid every hour (not 8 hours like others)
```

### HLP Returns
```
HLP APR = Trading Fees + Liquidations - Trader P&L
Historical: 20-50% APR
```

## Risk Spectrum

🟢 **Low Risk**: Spot-like positions (1-2x leverage)
🟡 **Medium Risk**: Moderate leverage (3-10x), HLP provision
🔴 **High Risk**: High leverage (10-30x), volatile assets
⚫ **Extreme Risk**: Max leverage (50x), meme perpetuals

## Learning Path

### Week 1: Basics
- Understand order book vs AMM
- Bridge funds to Hyperliquid
- Make first trades with low leverage

### Week 2: Intermediate
- Try different order types
- Understand funding rates
- Monitor liquidation levels

### Month 1: Advanced
- Provide HLP liquidity
- Try vault strategies
- Use advanced orders

### Month 2+: Master
- API integration
- Build trading bots
- Optimize strategies

## Essential Numbers

### Trading Limits
```
Minimum Order: $10
Maximum Leverage: 50x
Maker Fee: -0.02% (rebate!)
Taker Fee: 0.025%
Funding Interval: 1 hour
```

### HLP Statistics
```
TVL: $100M+ (varies)
Historical APR: 20-50%
Lock Period: None (instant withdrawal)
Entry/Exit Fee: 0%
```

### Position Limits
```
Tier 1 (BTC/ETH): $10M notional
Tier 2 (Major alts): $5M notional
Tier 3 (Small caps): $1M notional
```

## Quick Start Checklist

1. **Setup**
   - [ ] Create wallet (MetaMask)
   - [ ] Bridge USDC via Arbitrum
   - [ ] Connect to app.hyperliquid.xyz
   - [ ] Understand the interface

2. **First Trade**
   - [ ] Start with 2x leverage max
   - [ ] Use stop loss always
   - [ ] Trade liquid pairs first
   - [ ] Monitor funding rates

3. **Risk Management**
   - [ ] Never use >10% account per trade
   - [ ] Set daily loss limits
   - [ ] Track performance
   - [ ] Understand liquidations

## Common Pitfalls to Avoid

❌ **Over-leveraging** on first trades
❌ **Ignoring funding rates** (can drain account)
❌ **No stop losses** (quick liquidations)
❌ **Trading illiquid pairs** (wide spreads)
❌ **FOMO into pumps** (usually dumps follow)

## Key Metrics to Monitor

### For Traders
- Funding rates (hourly cost)
- Open interest (market sentiment)
- Volume (liquidity depth)
- Liquidation levels (support/resistance)

### For HLP Providers
- Vault P&L (daily/weekly)
- Trader performance (affects returns)
- TVL changes (dilution effect)
- APR trends (sustainability)

## Unique Features

### 1. Native Cross-Margin
All positions share margin automatically
No manual transfers needed
More capital efficient

### 2. Atomic Liquidations
Instant liquidation at exact price
No slippage or auction
Protects system integrity

### 3. Vault Ecosystem
Anyone can create vaults
Investors can copy strategies
Performance-based fees only

### 4. Points System
Trade to earn points
Points for future token
Early users advantaged

## Emergency Contacts

### Official Channels
- Website: hyperliquid.xyz
- Discord: Main support channel
- Twitter: @HyperliquidX
- Docs: docs.hyperliquid.xyz

### Never Trust
- DMs claiming to be support
- Unofficial Telegram groups
- "Airdrop" claims
- Wallet validators

## Tax Implications

### Every Trade Creates
- Taxable event (in most countries)
- Need to track:
  - Entry/exit prices
  - USD values
  - Funding payments
  - Realized P&L

### Tools for Tracking
- Export trade history CSV
- Use crypto tax software
- Keep detailed records
- Consult tax professional

## Future Developments

### Roadmap Items
- Native token launch
- Spot trading addition
- More chain integrations
- Mobile app
- Advanced order types
- Options trading

### Ecosystem Growth
- More vaults launching
- Third-party integrations
- Analytics platforms
- Trading competitions
- Institutional adoption