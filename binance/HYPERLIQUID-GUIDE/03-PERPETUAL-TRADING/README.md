# Perpetual Trading Complete Guide

## What Are Perpetuals?

Synthetic contracts that track spot price without expiry, allowing leveraged trading without owning the underlying asset.

### Perpetuals vs Spot vs Futures
```
Spot Trading:
- Own actual asset
- No leverage
- No liquidation
- Simple buy/sell

Futures (Traditional):
- Expiry date
- Settlement at maturity
- Contango/backwardation
- Roll costs

Perpetuals:
- No expiry
- Funding mechanism
- Continuous trading
- Most popular derivative
```

## Core Mechanics

### How Perpetuals Work
```
You trade price movements, not assets
Use margin as collateral
Leverage amplifies exposure
Funding keeps price aligned to spot
```

### Long vs Short

#### Going Long (Bullish)
```
Bet price will rise
Profit when price goes up
Loss when price goes down

Example:
Long BTC at $50,000
Price rises to $52,000
Profit: $2,000 per BTC
```

#### Going Short (Bearish)
```
Bet price will fall
Profit when price goes down
Loss when price goes up

Example:
Short BTC at $50,000
Price falls to $48,000
Profit: $2,000 per BTC
```

## Leverage Explained

### Understanding Leverage
```
Leverage = Position Size / Margin

1x: No leverage (like spot)
5x: Control 5x your margin
20x: Control 20x your margin
50x: Maximum on Hyperliquid
```

### Leverage Examples
```
With $1,000 margin:

1x leverage:
- Position size: $1,000
- 10% move = $100 profit/loss

10x leverage:
- Position size: $10,000
- 10% move = $1,000 profit/loss

50x leverage:
- Position size: $50,000
- 2% move = $1,000 profit/loss (liquidation!)
```

### Leverage Risk Matrix
```
Leverage | Liquidation Move | Risk Level
---------|------------------|------------
2x       | 50%             | Very Low
5x       | 20%             | Low
10x      | 10%             | Medium
20x      | 5%              | High
50x      | 2%              | Extreme
```

## Position Management

### Opening Positions

#### Market Order Entry
```
Pros:
- Instant execution
- Guaranteed fill
- No waiting

Cons:
- Pay taker fee (0.025%)
- Potential slippage
- No price control

When to use:
- Breakouts
- News events
- Strong conviction
```

#### Limit Order Entry
```
Pros:
- Earn maker rebate (-0.02%)
- Exact price control
- No slippage

Cons:
- May not fill
- Requires patience
- Can miss moves

When to use:
- Range trading
- Pullback entries
- Patient accumulation
```

### Position Sizing
```
Position Size = Account Risk / Trade Risk

Example:
Account: $10,000
Risk per trade: 2% = $200
Stop loss: 4% from entry
Position size: $200 / 0.04 = $5,000
At 10x leverage: $500 margin needed
```

### Managing Open Positions

#### Adding to Winners
```
Pyramid strategy:
Initial: $5,000 at $50,000
Add 1: $3,000 at $51,000
Add 2: $2,000 at $52,000

Average entry improves
Risk increases
Use trailing stops
```

#### Cutting Losses
```
Set maximum loss per trade
Don't average down losers
Use stop losses religiously

Rule: If down 5%, reassess
If down 10%, exit
Never let become liquidation
```

## P&L Calculations

### Long Position P&L
```
P&L = (Exit Price - Entry Price) / Entry Price × Position Size

Example:
Entry: $50,000
Exit: $52,500
Size: $100,000
P&L = (52,500 - 50,000) / 50,000 × 100,000
P&L = 0.05 × 100,000 = $5,000 (5%)
```

### Short Position P&L
```
P&L = (Entry Price - Exit Price) / Entry Price × Position Size

Example:
Entry: $50,000
Exit: $47,500
Size: $100,000
P&L = (50,000 - 47,500) / 50,000 × 100,000
P&L = 0.05 × 100,000 = $5,000 (5%)
```

### ROE Calculation
```
ROE% = P&L / Initial Margin × 100

Example:
P&L: $5,000
Margin: $5,000 (20x leverage)
ROE = 5,000 / 5,000 × 100 = 100%
```

## Funding Rates Deep Dive

### Purpose of Funding
```
Keeps perpetual price ≈ spot price
No arbitrage opportunity
Self-balancing mechanism

When perp > spot:
Funding positive → Longs pay shorts
Incentive to short → Price converges

When perp < spot:
Funding negative → Shorts pay longs
Incentive to long → Price converges
```

### Funding Calculation
```
Funding Rate = (Perp TWAP - Spot TWAP) / Spot TWAP
Capped at ±0.1% per hour typically

Payment = Position Size × Mark Price × Funding Rate
```

### Funding Strategy
```
High positive funding (>0.03%/hour):
- Consider shorting
- Or close longs
- 0.72% daily cost!

High negative funding (<-0.03%/hour):
- Consider longing
- Or close shorts
- Earning 0.72% daily!
```

### Real Examples
```
Bullish market funding:
BTC funding: 0.05%/hour
Daily cost for longs: 1.2%
Annual: 438%!

Strategy: Short-term trades only
Or use spot for holding
```

## Market Dynamics

### Open Interest
```
Total value of open positions
Indicates market positioning

Rising OI + Rising price = Bullish
Rising OI + Falling price = Bearish
Falling OI = Closing positions
```

### Long/Short Ratio
```
Shows market sentiment
>1.5 = Heavily long
<0.7 = Heavily short
1.0 = Balanced

Contrarian signal often
Extreme = potential reversal
```

### Volume Analysis
```
High volume + Price up = Strong bullish
High volume + Price down = Strong bearish
Low volume moves = Weak/false

Volume precedes price
Watch for divergences
```

## Advanced Trading Concepts

### Basis Trading
```
Spread between perp and spot
Arbitrage opportunity

Example:
Spot BTC: $49,900
Perp BTC: $50,100
Basis: $200 (0.4%)

Strategy:
Long spot, short perp
Collect funding + convergence
```

### Delta Neutral Strategies
```
Hedge directional risk
Earn funding only

Setup:
$10,000 spot BTC
$10,000 short perp
Net exposure: $0

Earn: Funding payments
Risk: Basis risk only
```

### Spread Trading
```
Trade relative value
Lower risk than directional

Example:
Long ETH/BTC spread
Long 1 ETH perp
Short equivalent BTC perp
Profit if ETH outperforms
```

## Trading Strategies

### Trend Following
```
Identify trend direction
Enter on pullbacks
Ride with trailing stop

Indicators:
- Moving averages
- Higher highs/lows
- Volume confirmation

Example:
BTC above 50 MA
Wait for pullback to MA
Long with stop below
```

### Range Trading
```
Buy support, sell resistance
Works in sideways markets
Use limit orders

Setup:
Range: $49,000 - $51,000
Buy at $49,100
Sell at $50,900
Stop outside range
```

### Breakout Trading
```
Trade range breakouts
High risk/reward
Use stops religiously

Entry:
Break above $51,000
Confirm with volume
Target: Range height
Stop: Back in range
```

### Mean Reversion
```
Fade extreme moves
Counter-trend strategy
Requires patience

Setup:
RSI < 30 (oversold)
Enter long gradually
Target: Mean price
Stop: New lows
```

## Risk Management

### The 2% Rule
```
Never risk >2% per trade
Preserves capital
Allows recovery

Math:
20 losses of 2% = 33% drawdown
20 losses of 5% = 65% drawdown
20 losses of 10% = 89% drawdown
```

### Position Correlation
```
Don't overexpose to one theme
BTC + ETH + SOL = 3x crypto risk
Diversify or reduce size

Maximum correlation exposure: 50%
```

### Maximum Drawdown
```
Set account stop loss
If down 20%, stop trading
Reassess strategy
Reduce size on return

Recovery math:
-20% needs +25% to breakeven
-50% needs +100% to breakeven
```

## Common Patterns

### Liquidation Cascades
```
Mass liquidations trigger more
Rapid price moves
High volatility

Signs:
- Overleveraged market
- Clustering of stops
- Low liquidity

Protection:
- Lower leverage
- Wider stops
- Hedge positions
```

### Funding Squeeze
```
Extreme funding rates
Force position closes
Price reversal follows

Example:
Funding 0.1%/hour
Longs paying 2.4%/day
Mass closing → Price drops
```

### Weekend Dynamics
```
Lower liquidity
Wider spreads
Unexpected moves
Higher volatility

Strategy:
- Reduce position size
- Widen stops
- Avoid new positions
- Or exploit volatility
```

## Psychological Aspects

### FOMO Control
```
Fear of missing out
Leads to bad entries
Chasing price

Solution:
- Have entry rules
- Wait for setup
- Multiple opportunities
- Focus on process
```

### Revenge Trading
```
Trading to recover losses
Emotional decisions
Increases risk

Prevention:
- Daily loss limits
- Forced breaks
- Review before continue
- Smaller size after loss
```

### Overconfidence
```
After winning streak
Increase size/leverage
One loss wipes gains

Management:
- Consistent sizing
- Regular withdrawals
- Stay humble
- Follow system
```

## Performance Metrics

### Key Statistics
```
Win Rate: Winning trades / Total trades
Avg Win: Average winning trade
Avg Loss: Average losing trade
Profit Factor: Gross profit / Gross loss

Good metrics:
Win rate: >50%
Risk/Reward: >1.5
Profit Factor: >1.5
Sharpe Ratio: >1.0
```

### Trading Journal
```
Track every trade:
- Entry/exit prices
- Position size
- Leverage used
- P&L result
- Market conditions
- Emotions/notes

Review weekly:
- What worked
- What didn't
- Patterns emerging
- Areas to improve
```

## Platform-Specific Features

### Hyperliquid Advantages
```
✅ Maker rebates (-0.02%)
✅ No gas fees
✅ Sub-second execution
✅ Deep liquidity
✅ Cross-margin default
```

### Unique Tools
```
- Integrated TradingView
- Real-time P&L
- Funding countdown
- Liquidation heatmap
- Vault strategies
```

## Best Practices Summary

### Daily Routine
```
Morning:
1. Check major news
2. Review positions
3. Note key levels
4. Plan trades

Trading:
1. Follow plan
2. Manage risk
3. Take profits
4. Cut losses

Evening:
1. Review trades
2. Journal notes
3. Set alerts
4. Plan tomorrow
```

### Rules for Success
```
1. Always use stop loss
2. Never add to losers
3. Take partial profits
4. Respect leverage
5. Monitor funding
6. Track performance
7. Stay educated
8. Control emotions
9. Follow system
10. Preserve capital
```