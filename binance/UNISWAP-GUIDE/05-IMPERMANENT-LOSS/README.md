# Impermanent Loss Complete Guide

## What Is Impermanent Loss?

The difference between holding tokens vs providing liquidity when prices change.

### Simple Definition
```
You deposit: 1 ETH + $4,000 USDC
ETH doubles to $8,000
If held: 1 ETH + $4,000 = $12,000
In pool: Worth $11,313
IL = $687 (5.7%)
```

## The Mathematics

### Core IL Formula
```
IL = 2 × √(price_ratio) / (1 + price_ratio) - 1

Where:
price_ratio = price_end / price_start
```

### IL Table
```
Price Change | IL %
-------------|-------
0.25x        | -5.72%
0.5x         | -5.72%
0.75x        | -1.03%
0.9x         | -0.28%
1x (no change)| 0%
1.1x         | -0.23%
1.25x        | -0.60%
1.5x         | -2.02%
2x           | -5.72%
3x           | -13.40%
4x           | -20.00%
5x           | -25.46%
10x          | -42.51%
```

### Key Insights
```
- IL same for 2x up or 0.5x down
- Symmetric around no change
- Accelerates with larger moves
- Always negative (loss)
- "Impermanent" until withdrawn
```

## Why IL Happens

### The Rebalancing Effect
```
Pool maintains 50/50 value ratio
Price up → Sells rising token
Price down → Buys falling token

Always:
- Selling winners
- Buying losers
- Opposite of profit
```

### Detailed Example
```
Initial:
10 ETH × 40,000 USDC = 400,000 (k)
Price: $4,000/ETH

ETH rises to $5,000:
New ratio needed for k = 400,000
8.944 ETH × 44,721 USDC = 400,000
Pool sold 1.056 ETH for 4,721 USDC

Value in pool: $44,721 + $44,721 = $89,442
If held: 10 ETH + $40,000 = $90,000
IL: $558 (0.6%)
```

### The AMM Curse
```
AMMs always:
1. Provide liquidity at all prices
2. Maintain constant product
3. Rebalance automatically

Result: Systematic underperformance vs holding
```

## IL in Different Scenarios

### Volatile Pairs (ETH/USDC)
```
High IL risk
One stable, one volatile
Divergent price paths

Typical IL:
- Daily: 0-2%
- Weekly: 0-5%
- Monthly: 0-20%
- Yearly: 0-50%
```

### Correlated Pairs (ETH/WBTC)
```
Lower IL risk
Both move similarly
Correlation reduces divergence

Typical IL:
- Daily: 0-0.5%
- Weekly: 0-1%
- Monthly: 0-3%
- Yearly: 0-10%
```

### Stable Pairs (USDC/USDT)
```
Minimal IL risk
Pegged to same value
Tiny price movements

Typical IL:
- Daily: 0-0.01%
- Weekly: 0-0.02%
- Monthly: 0-0.05%
- Yearly: 0-0.1%
```

### Exotic Pairs (ETH/SHITCOIN)
```
Extreme IL risk
Uncorrelated movements
One can go to zero

Typical IL:
- Daily: 0-10%
- Weekly: 0-30%
- Monthly: 0-70%
- Can be 100% (total loss)
```

## V2 vs V3 Impermanent Loss

### V2 IL Characteristics
```
- Spread across infinite range
- IL diluted across price spectrum
- Always earning fees
- Gradual IL accumulation
```

### V3 IL Characteristics
```
- Concentrated in range
- Amplified IL effect
- No fees out of range
- Can be 100% loss quickly

Concentration multiplier:
10x concentration ≈ 3-4x IL speed
```

### V3 IL Example
```
V2 Position:
Price doubles → 5.7% IL

V3 Position (±10% range):
Price moves 11% → Out of range
100% in one token → Massive IL
No fee compensation
```

## Calculating Real Returns

### Net Return Formula
```
Net Return = Fee Earnings - Impermanent Loss + Price Appreciation

Example:
Fees earned: +10%
IL: -5%
ETH appreciation: +20% (on half position)
Net: 10% - 5% + 10% = +15%
```

### Break-Even Analysis
```
Fees Needed = IL + Gas Costs + Opportunity Cost

Price doubles (5.7% IL)
Gas costs: 1%
Opportunity: 2%
Need: 8.7% from fees to break even
```

### Time Factor
```
Daily fees: 0.1%
Monthly: 3%
IL from 20% move: 2%
Net monthly: +1%

But single 50% spike:
IL: 5.7%
Need 57 days of fees to recover
```

## IL Mitigation Strategies

### 1. Stable/Correlated Pairs Only
```
Trade-off:
✅ IL < 1% typically
✅ Predictable returns
❌ Lower fees (less volume)
❌ Lower APR overall

Best pairs:
- USDC/USDT
- stETH/ETH
- WBTC/renBTC
```

### 2. Narrow V3 Ranges
```
Strategy: Exit before big moves

Range: ±5%
Rebalance: At ±4% move
IL per cycle: <1%
Fees concentrated: 20x

Risk: Miss big moves
Cost: High gas fees
```

### 3. Single-Sided Strategies
```
V3 range orders:
Above price: USDC only
Below price: ETH only

No IL if price doesn't cross
Functions like limit orders
Earn fees while waiting
```

### 4. Delta Hedging
```
LP Position: 1 ETH + $4,000 USDC
Hedge: Short 0.5 ETH futures

Price doubles:
LP IL: -$687
Futures profit: +$2,000
Net gain: +$1,313
```

### 5. Options Protection
```
Buy protective puts
Cost: Premium (2-5%)
Protects downside
Keeps upside potential

Example:
LP $10,000
Buy $9,000 put for $200
Max loss: $1,200
```

### 6. Dynamic Rebalancing
```
Set IL tolerance: 2%
When reached: Rebalance
Reset to 50/50
Realize small IL frequently

Better than one large IL
```

## Advanced IL Concepts

### Path Dependency
```
IL depends on path taken!

Scenario A:
ETH: $4,000 → $8,000 direct
IL: 5.7%

Scenario B:
ETH: $4,000 → $2,000 → $8,000
IL: Higher! (compounded)
```

### Fees vs IL Crossover
```
When fees > IL:
Net positive return

Critical volume needed:
Volume = IL / (Fee Rate × Share)

Example:
5% IL, 0.3% fee, 1% pool share
Need: 5% / (0.003 × 0.01) = $1.67M volume
```

### IL in Multi-Asset Pools
```
Balancer pools (>2 assets)
More complex IL

Formula for n assets:
IL harder to calculate
Generally lower than 2-asset
Diversification benefit
```

## Real World Examples

### DeFi Summer 2020
```
ETH: $200 → $400
Many LPs:
- Fees: +50% APR
- IL: -5.7%
- Net: +44.3%
Winners despite IL
```

### May 2021 Crash
```
ETH: $4,000 → $2,000
LPs experienced:
- Fees: +2%
- IL: -5.7%
- Price loss: -25% (on half)
- Net: -28.7%
Better than holding ETH (-50%)
```

### Stable Depeg Events
```
USDC depeg to $0.87:
USDC/USDT LPs:
- IL: -0.8%
- Fees during volatility: +5%
- Net: +4.2%
Profited from chaos
```

## IL Calculators & Tools

### Online Calculators
```
- dailydefi.org/tools/impermanent-loss-calculator/
- app.metacrypt.org/tools/impermanent-loss-calculator/
- baller.netlify.app/
```

### Portfolio Trackers
```
Track IL in real-time:
- apy.vision
- revert.finance
- zapper.fi
- debank.com
```

### Backtesting Tools
```
Historical IL analysis:
- croco.finance
- flipside.crypto
- dune.com dashboards
```

## Common IL Misconceptions

### "It's Only a Loss if You Withdraw"
```
FALSE: Opportunity cost is real
While waiting for recovery:
- Missing other opportunities
- Fees might not compensate
- Could get worse
```

### "Fees Always Compensate"
```
FALSE: Depends on:
- Volume/TVL ratio
- Price volatility
- Time frame
Many pools never break even
```

### "Stable Pairs Have No IL"
```
FALSE: Still exists, just smaller
USDT/USDC can have IL
During depegs: Significant
Always non-zero risk
```

### "IL Is Temporary"
```
MISLEADING: Only if price returns
Most prices don't return
New equilibriums form
Can be permanent
```

## Risk Management Framework

### Position Sizing
```
Never >20% portfolio in LP
Diversify IL risk:
- Multiple pairs
- Different correlations
- Various protocols
```

### Stop Loss Rules
```
Set max IL tolerance:
Conservative: 5%
Moderate: 10%
Aggressive: 20%

Exit if breached
Don't hope for recovery
```

### IL Budget
```
Treat IL like cost:
"I'll pay 5% IL for 20% APR"
If IL > budget: Exit
If fees > IL: Continue
Regular reassessment
```

## Psychological Aspects

### Loss Aversion
```
Seeing IL feels bad
Even if net positive
Focus on total return
Not just IL component
```

### FOMO vs Discipline
```
See 500% APR pool
Ignore 50% IL risk
FOMO overrides logic

Stick to strategy
Calculate break-even
Be realistic
```

### The Hold vs LP Decision
```
Hold if:
- Expecting big moves
- Can't monitor actively
- Gas costs high

LP if:
- Sideways market expected
- High volume/TVL ratio
- Active management possible
- Fees > Expected IL
```

## Tax Considerations

### IL Tax Treatment
```
Complex area!

Possible interpretations:
1. Capital loss when withdrawn
2. Ordinary loss
3. Not deductible

Consult tax professional
Track everything
```

### Record Requirements
```
Document:
- Entry prices/amounts
- Exit prices/amounts
- Fees earned
- IL calculated
- USD values throughout
```

## Future Developments

### IL Protection Protocols
```
- Bancor (IL insurance)
- Thorchain (IL protection)
- New mechanisms developing

Trade-offs:
- Lower APR
- Protected principal
- Complexity
```

### New AMM Models
```
Curve V2: Dynamic pegs
Uniswap V4: Custom curves
Trader Joe: Dynamic fees

All trying to minimize IL
None eliminate completely
```

## Summary Rules

### The IL Commandments
```
1. IL is unavoidable in AMMs
2. Bigger price moves = Bigger IL
3. Fees must exceed IL to profit
4. V3 concentration amplifies IL
5. Stable pairs minimize IL
6. Time doesn't heal IL
7. Calculate before entering
8. Have exit strategy
9. Track performance daily
10. Learn from each position
```