# Uniswap Complete Master Guide

## Quick Navigation

### Foundation
- [01 - DeFi Fundamentals](01-DEFI-FUNDAMENTALS/README.md) - AMM vs Order Book
- [02 - Swapping Basics](02-SWAPPING-BASICS/README.md) - How to trade

### Liquidity Provision
- [03 - LP Basics (V2)](03-LIQUIDITY-PROVISION/README.md) - Provide liquidity
- [04 - Uniswap V3](04-UNISWAP-V3/README.md) - Concentrated liquidity
- [05 - Impermanent Loss](05-IMPERMANENT-LOSS/README.md) - Risk mathematics

### Advanced
- [06 - Advanced Strategies](06-ADVANCED-STRATEGIES/README.md) - MEV, arbitrage
- [07 - Tools & Analytics](07-TOOLS-ANALYTICS/README.md) - Data & automation
- [08 - Safety & Risks](08-SAFETY-RISKS/README.md) - Security best practices

## Core Concepts Quick Reference

### AMM Formula (V2)
```
x × y = k
Where:
x = Token A reserves
y = Token B reserves
k = Constant product
```

### Price Impact
```
Price Impact = ((New Price / Old Price) - 1) × 100%
Slippage = Price Impact + Fee
```

### Impermanent Loss
```
IL = 2√(price_ratio) / (1 + price_ratio) - 1
```

### V3 Capital Efficiency
```
V2: Liquidity spread 0 to ∞
V3: Liquidity concentrated in range
Efficiency gain: 4000x maximum
```

## Risk Levels

🟢 **Low Risk**: Swapping major pairs with low slippage
🟡 **Medium Risk**: Providing liquidity to stable pairs
🔴 **High Risk**: LP volatile pairs, leveraged positions
⚫ **Extreme Risk**: New token LPs, full range V3

## Key Differences: CEX vs DEX

| Feature | Binance (CEX) | Uniswap (DEX) |
|---------|--------------|---------------|
| Custody | Exchange holds | You hold keys |
| KYC | Required | None |
| Order Type | Limit/Market | Market only |
| Price Discovery | Order book | AMM formula |
| Fees | 0.1% | 0.3%/0.05%/0.01% |
| Speed | Instant | 12 sec (block) |
| Liquidity | Professional MMs | Anyone can LP |

## Learning Path

### Week 1: Basics
- Understand AMM vs order book
- Make first swap
- Calculate price impact

### Week 2: Intermediate
- Provide V2 liquidity
- Track impermanent loss
- Use analytics tools

### Month 2: Advanced
- Try V3 positions
- Understand MEV
- Build strategies

### Month 3+: Master
- Active V3 management
- Cross-protocol strategies
- Automation setup

## Essential Formulas

### Swap Output Calculation
```
Output = (Input × 997 × ReserveOut) / (ReserveIn × 1000 + Input × 997)
```

### LP Token Value
```
LP Value = 2 × √(Reserve_A × Reserve_B × Price_A × Price_B)
```

### V3 Liquidity Calculation
```
L = sqrt(x × y)
L = Δy / Δ√P (when adding single-sided)
```

## Gas Optimization Tips

1. **Swap during low activity** (weekends, 2-6 AM UTC)
2. **Use V3 for large trades** (better pricing)
3. **Direct routing** when possible
4. **Batch transactions** with multicall

## Common Pitfalls

❌ **High slippage** on low liquidity pairs
❌ **MEV sandwich** attacks on large trades
❌ **Wrong network** (sending to Ethereum address on Polygon)
❌ **Infinite approval** risks
❌ **Ignoring IL** in volatile pairs

## Quick Stats

- Total Volume: >$1.5 Trillion
- TVL: $3-10 Billion (varies)
- Daily Volume: $1-3 Billion
- Unique Traders: >4 Million
- V2 Pools: >100,000
- V3 Pools: >10,000