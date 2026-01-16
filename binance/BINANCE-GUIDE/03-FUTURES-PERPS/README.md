# Perpetual Futures Complete Guide

## What Are Perpetual Futures?

Synthetic contracts that track spot price without expiry date. You trade price movements without owning assets.

### Historical Context
- **Traditional Futures**: Expire monthly/quarterly, physical delivery
- **Perpetuals** (2016): BitMEX invention, no expiry, cash-settled
- **Purpose**: Leverage + shorting + hedging

### Core Concept
```
Spot Trading: Buy 1 BTC for $50,000 (need $50,000)
Perpetual: Control 1 BTC with $500 margin at 100x leverage
```

## Financial Mechanics

### 1. Leverage Explained
```
Leverage = Position Size / Margin
Position Size = Margin × Leverage

Example:
Margin: $1,000
Leverage: 10x
Position Size: $10,000
```

### 2. P&L Calculation

#### Long Position (Betting Price Up)
```
P&L = (Exit Price - Entry Price) × Position Size / Entry Price
ROE% = P&L / Initial Margin × 100

Example:
Entry: $50,000, Exit: $52,000
Position: 0.2 BTC, Margin: $2,000 (5x leverage)
P&L = (52,000 - 50,000) × 0.2 = $400
ROE = 400/2,000 × 100 = 20%
```

#### Short Position (Betting Price Down)
```
P&L = (Entry Price - Exit Price) × Position Size / Entry Price
ROE% = P&L / Initial Margin × 100

Example:
Entry: $50,000, Exit: $48,000
Position: 0.2 BTC, Margin: $2,000
P&L = (50,000 - 48,000) × 0.2 = $400
ROE = 400/2,000 × 100 = 20%
```

### 3. Liquidation Mathematics

#### Liquidation Price Formula

**For Long Positions:**
```
Liq Price = Entry Price × (1 - Initial Margin Rate + Maintenance Margin Rate)

Where:
Initial Margin Rate = 1 / Leverage
Maintenance Margin Rate = 0.5% (varies by exchange)

Example (100x leverage):
Entry: $50,000
Initial Margin: 1%
Maintenance: 0.5%
Liq Price = 50,000 × (1 - 0.01 + 0.005) = $49,750
```

**For Short Positions:**
```
Liq Price = Entry Price × (1 + Initial Margin Rate - Maintenance Margin Rate)

Example (100x leverage):
Entry: $50,000
Liq Price = 50,000 × (1 + 0.01 - 0.005) = $50,250
```

### 4. Funding Rate Mechanism

#### What Is Funding?
Periodic payments between longs and shorts to keep perp price ≈ spot price.

```
Funding Payment = Position Value × Funding Rate

If rate positive: Longs pay shorts
If rate negative: Shorts pay longs
```

#### Funding Rate Calculation
```
Funding Rate = Clamp(MA((Premium Index - Interest), Interval), -0.75%, 0.75%)
Premium Index = (Max(0, Bid - Spot) - Max(0, Spot - Ask)) / Spot
Interest = 0.01% (fixed daily)
```

#### Real Example
```
Position: 1 BTC long at $50,000
Funding Rate: 0.01% (every 8 hours)
Payment: $50,000 × 0.01% = $5 (you pay)
Daily cost: $5 × 3 = $15
APR equivalent: 10.95%
```

## Margin Systems

### 1. Isolated Margin
```
Each position has dedicated margin
Loss limited to position margin
Can't share margin between positions

Example:
Position 1: $1000 margin (can lose max $1000)
Position 2: $500 margin (can lose max $500)
Account: Other funds safe
```

### 2. Cross Margin
```
All positions share account balance
Losses offset by total balance
Higher risk, lower liquidation chance

Example:
Account: $10,000
Position 1: -$2000 P&L
Position 2: +$1000 P&L
Net: Uses $1000 from account
```

### Comparison
| Aspect | Isolated | Cross |
|--------|----------|--------|
| Risk | Limited | Entire account |
| Liquidation | Quicker | Slower |
| Management | Per position | Global |
| Use Case | Testing/Learning | Experienced/Hedging |

## Order Types & Advanced Features

### 1. Take Profit / Stop Loss (TP/SL)

#### Take Profit
```
Entry: $50,000 long
TP at: $52,000
Trigger: Price hits $52,000 → Market sell
Lock in: $2,000 profit per BTC
```

#### Stop Loss
```
Entry: $50,000 long
SL at: $49,000
Trigger: Price hits $49,000 → Market sell
Limit: $1,000 loss per BTC
```

#### Trailing Stop
```
Entry: $50,000
Trailing: 2%
Price → Stop Level
$50,000 → $49,000
$51,000 → $49,980
$52,000 → $50,960
Triggers at 2% pullback from peak
```

### 2. Reduce-Only Orders
Prevents increasing position size. Only closes/reduces.

```
Position: 1 BTC long
Reduce-only sell: 0.5 BTC → Allowed
Reduce-only sell: 1.5 BTC → Rejected (would go short)
```

### 3. Position Management

#### Adding to Position (Averaging)
```
Initial: 1 BTC at $50,000
Add: 1 BTC at $49,000
New Average: $49,500
New Size: 2 BTC

Warning: Increases liquidation risk
```

#### Partial Close
```
Position: 2 BTC long at $50,000
Market moves to $51,000
Close 50%: Lock in 1 BTC × $1000 = $1000 profit
Keep 50%: Let 1 BTC run
```

## Risk Parameters

### 1. Maximum Leverage by Asset
```
BTC/ETH: 125x
Major Alts: 75x
Mid Caps: 50x
Small Caps: 20x

Risk Level:
1-5x: Conservative
5-10x: Moderate
10-20x: Aggressive
20x+: Extreme (gambling)
```

### 2. Position Limits
```
Notional Limit = f(Leverage, Asset)
Example BTC:
125x leverage: $50,000 max
20x leverage: $500,000 max
5x leverage: $5,000,000 max
```

### 3. Maintenance Margin Requirements
| Position Value | Maint. Margin | Max Leverage |
|----------------|---------------|--------------|
| 0-50k | 0.4% | 125x |
| 50k-250k | 0.5% | 100x |
| 250k-1M | 1.0% | 50x |
| 1M-5M | 2.5% | 20x |
| 5M+ | 5.0% | 10x |

## Hedging Strategies

### 1. Delta Neutral
```
Spot: Own 1 BTC at $50,000
Futures: Short 1 BTC at $50,000
Result: No price exposure, earn funding
```

### 2. Protective Hedge
```
Spot: Own 10 BTC (long-term hold)
Futures: Short 3 BTC (30% hedge)
Result: Protected against 30% of downside
```

### 3. Basis Trade
```
Spot Price: $50,000
Futures Price: $51,000 (2% premium)
Strategy: Buy spot, short futures
Profit: $1,000 at convergence
```

## Common Strategies & Math

### 1. Funding Rate Arbitrage
```
When funding > 0.01%:
- Long spot
- Short perp
- Collect funding

Daily return = Funding × 3 - Fees
Example: 0.01% × 3 = 0.03% daily = 10.95% APR
```

### 2. Momentum Trading
```
Entry: Break above $50,000 resistance
Stop: $49,500 (1% risk)
Target: $52,500 (5% reward)
Risk/Reward: 1:5
Win Rate Needed: >16.67% for profit
```

### 3. Mean Reversion
```
Entry: RSI < 30 (oversold)
Position Size: Account × 2% risk
Exit: RSI > 50 or stop loss
Expected Value = (Win% × Avg Win) - (Loss% × Avg Loss)
```

## Interface Features Explained

### Main Trading Panel
```
[Leverage Slider: 1x -----------●---- 125x]
[Margin Mode: ● Cross ○ Isolated]
[Order Type: Limit ▼]
[Price: $50,000] [Amount: 0.1 BTC]
[Cost: 500 USDT] [Available: 10,000 USDT]
```

### Position Display
```
Symbol | Size | Entry | Mark | Liq | P&L | ROE% | Margin
BTC    | 0.1  | 50000 | 50500 | 49750 | +50 | +10% | 500
```

### Advanced Calculator
```
Entry Price: [    ]
Position Size: [    ]
Leverage: [    ]
→ Initial Margin: $XXX
→ Liquidation Price: $XXX
→ Price Move to Liq: -X%
```

## Critical Risks

### 1. Liquidation Cascade
```
Large position liquidated
→ Market sell order
→ Price drops
→ More liquidations
→ Flash crash

Protection: Use stop loss before liquidation
```

### 2. Funding Drain
```
High positive funding (0.1%/8hr)
= 0.3% daily
= 109.5% annually!
Can destroy profits
```

### 3. Scam Wicks
```
Low liquidity period
→ Large market order
→ Price spike/crash
→ Liquidate high leverage
→ Price returns

Protection: Lower leverage, limit orders
```

### 4. Exchange Risk
- Maintenance/downtime
- Hacks
- Regulatory shutdown
- Withdrawal freezes

## Psychology & Discipline

### Common Mistakes
1. **Revenge trading** after losses
2. **Overleveraging** on "sure things"
3. **No stop loss** ("it'll come back")
4. **Position sizing** too large
5. **FOMO** entries at tops
6. **Panic selling** at bottoms

### Risk Management Rules
```
1. Risk per trade: Max 1-2% of account
2. Daily loss limit: Max 5% of account
3. Correlation limit: Max 3 correlated positions
4. Leverage rule: Start at 3x, earn higher
5. Journal requirement: Log every trade
```

### Position Size Formula
```
Position Size = (Account × Risk%) / (Entry - Stop)

Example:
Account: $10,000
Risk: 1% = $100
Entry: $50,000
Stop: $49,500
Size = 100 / 500 = 0.2 BTC
```

## Tax Considerations

### Perpetual Tax Treatment
- Each close is taxable event
- Funding payments = income
- Losses can offset gains
- Keep detailed records

### Required Records
```
- Open timestamp
- Close timestamp
- Entry price
- Exit price
- Size
- P&L in USD
- Funding paid/received
- Fees
```

## Emergency Procedures

### Position Underwater
1. Don't add to losing position
2. Set mental stop loss
3. Consider hedging opposite
4. Reduce position size
5. Never deposit more to "save"

### Can't Close Position
1. Try different order types
2. Use reduce-only market
3. Contact support immediately
4. Hedge on another exchange

### Liquidation Approaching
1. Add margin (careful!)
2. Partial close to reduce size
3. Set stop above liquidation
4. Accept loss, don't fight

## Pro Trading Setup

### Tools Needed
- TradingView (charting)
- Coinglass (liquidations)
- Coinmarketcal (events)
- Position calculator
- Risk journal

### Recommended Progression
```
Week 1-2: Paper trade only
Week 3-4: 1x leverage, $100
Month 2: 2-3x leverage, $500
Month 3: 3-5x leverage, $1000
Month 6: 5-10x max
Never: Above 20x for serious trading
```

### Success Metrics
```
Sharpe Ratio = (Return - Risk Free Rate) / StdDev
Good > 1.0

Win Rate = Winning Trades / Total Trades
Profitable if > 1 / (1 + Risk:Reward)

Profit Factor = Gross Profits / Gross Losses
Good > 1.5
```