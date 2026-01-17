# Risk Management & Liquidations Complete Guide

## Understanding Risk in Perpetuals

### Types of Risk
```
1. Market Risk: Price moves against you
2. Leverage Risk: Amplified losses
3. Liquidation Risk: Total position loss
4. Funding Risk: Holding costs
5. Liquidity Risk: Slippage on exit
6. Platform Risk: Technical issues
7. Black Swan Risk: Extreme events
```

### Risk Hierarchy
```
Extreme Risk ← High Leverage (20-50x)
     ↑
High Risk ← Moderate Leverage (10-20x)
     ↑
Medium Risk ← Low Leverage (5-10x)
     ↑
Low Risk ← Minimal Leverage (2-5x)
     ↑
Base Risk ← No Leverage (1x)
```

## Liquidation Mechanics

### What Is Liquidation?
```
Forced closure of position when margin insufficient
Happens when losses exceed margin
Results in total loss of position margin
Protects platform from bad debt
```

### Liquidation Formula

#### For Long Positions
```
Liquidation Price = Entry Price × (1 - 1/Leverage + Maintenance Margin)

Example:
Entry: $50,000
Leverage: 20x
Initial Margin: 5% (1/20)
Maintenance: 0.5%
Liq Price = $50,000 × (1 - 0.05 + 0.005)
Liq Price = $50,000 × 0.955
Liq Price = $47,750

Price drops 4.5% = Liquidation
```

#### For Short Positions
```
Liquidation Price = Entry Price × (1 + 1/Leverage - Maintenance Margin)

Example:
Entry: $50,000
Leverage: 20x
Liq Price = $50,000 × (1 + 0.05 - 0.005)
Liq Price = $50,000 × 1.045
Liq Price = $52,250

Price rises 4.5% = Liquidation
```

### Maintenance Margin Requirements
```
Tier    | Position Size | Maint. Margin | Max Leverage
--------|--------------|---------------|-------------
Tier 1  | <$50k        | 0.3%         | 50x
Tier 2  | $50k-250k    | 0.5%         | 50x
Tier 3  | $250k-1M     | 1.0%         | 30x
Tier 4  | $1M-5M       | 2.5%         | 20x
Tier 5  | >$5M         | 5.0%         | 10x
```

### Liquidation Process
```
1. Position margin ratio falls below maintenance
2. Liquidation engine triggers instantly
3. Position closed at mark price
4. Remaining margin (if any) to insurance fund
5. If insufficient, insurance fund covers
6. Account can continue trading with remaining funds
```

## Position Sizing

### The Kelly Criterion
```
Optimal Size = (p×b - q) / b

Where:
p = probability of winning
b = win/loss ratio
q = probability of losing (1-p)

Example:
60% win rate, 2:1 risk/reward
f = (0.6×2 - 0.4) / 2 = 0.4
Optimal: 40% of capital (too high!)
Use 1/4 Kelly = 10% for safety
```

### Practical Position Sizing
```
Conservative: 1-2% risk per trade
Moderate: 2-5% risk per trade
Aggressive: 5-10% risk per trade
Reckless: >10% risk per trade

Account: $10,000
2% risk: $200 max loss per trade
```

### Position Size Calculation
```
Position Size = (Account Risk %) / (Stop Loss %)

Example:
Account: $10,000
Risk: 2% = $200
Stop: 4% from entry
Position: $200 / 0.04 = $5,000
Leverage needed: $5,000 / $200 = 25x
```

## Risk Management Strategies

### The Core Rules

#### Rule 1: Never Risk More Than You Can Lose
```
Define maximum acceptable loss
Per trade: 1-2%
Per day: 5%
Per week: 10%
Per month: 20%

Stops trading if limits hit
```

#### Rule 2: Always Use Stop Losses
```
Set before entering
Non-negotiable rule
Types:
- Fixed % stop (2-5%)
- ATR-based stop (2×ATR)
- Support/resistance stop
- Time stop (exit after X hours)
```

#### Rule 3: Respect Leverage
```
Starting leverage: 2-5x
Earned privilege: 5-10x
Professional: 10-20x
Dangerous: 20-50x

Higher leverage = Tighter stops needed
```

### Advanced Risk Techniques

#### Portfolio Heat
```
Total portfolio risk exposure
Sum of all open trade risks

Example:
Trade 1: 2% risk
Trade 2: 1.5% risk
Trade 3: 2% risk
Total Heat: 5.5%

Maximum heat: 6-10%
```

#### Correlation Risk
```
Similar positions amplify risk
BTC + ETH + SOL = 3x crypto exposure

Correlation matrix:
BTC-ETH: 0.8
BTC-SOL: 0.7
ETH-SOL: 0.75

Adjust size for correlation
```

#### Volatility Adjustment
```
ATR Position Sizing:
Position = (Risk Amount) / (ATR × Multiplier)

High volatility → Smaller positions
Low volatility → Larger positions

Example:
Risk: $500
ATR: $1,000
Multiplier: 2
Position: $500 / $2,000 = 0.25 BTC
```

## Avoiding Liquidation

### Safety Margins

#### Leverage Selection
```
Safe zones by leverage:
2x: 50% move to liquidation
5x: 20% move to liquidation
10x: 10% move to liquidation
20x: 5% move to liquidation
50x: 2% move to liquidation

Choose based on volatility:
BTC daily move: 2-5% typical
Safe leverage: 10-20x max
```

#### Buffer Calculation
```
Never use maximum leverage
Keep 20-30% margin buffer

Example:
Could use 50x
Use 35x instead
Extra room for volatility
```

### Warning Signs

#### Pre-Liquidation Signals
```
⚠️ Margin ratio <10%
⚠️ Unrealized loss >50%
⚠️ Price near liquidation
⚠️ Funding eating margin
⚠️ Unable to add positions
```

#### Emergency Actions
```
1. Add more margin
2. Reduce position size
3. Close partial position
4. Hedge opposite direction
5. Close entirely

Priority: Preserve capital
```

## Managing Drawdowns

### Drawdown Recovery Math
```
Drawdown | Gain Needed to Recover
---------|----------------------
-10%     | +11.1%
-20%     | +25%
-30%     | +42.9%
-40%     | +66.7%
-50%     | +100%
-75%     | +300%
-90%     | +900%

Lesson: Avoid large drawdowns!
```

### Drawdown Management
```
At -10%: Review strategy
At -20%: Reduce position size by 50%
At -30%: Stop trading, reassess
At -40%: Major strategy overhaul
Never: Let reach -50%+
```

### Recovery Strategy
```
After drawdown:
1. Take break (minimum 24 hours)
2. Review what went wrong
3. Reduce size significantly
4. Focus on base hits
5. Rebuild confidence slowly
6. Only increase after profit
```

## Risk Metrics

### Key Measurements

#### Sharpe Ratio
```
Sharpe = (Return - Risk Free Rate) / Volatility

> 3.0: Excellent
2.0-3.0: Very good
1.0-2.0: Good
0.5-1.0: Acceptable
< 0.5: Poor

Good strategy: Sharpe > 1.5
```

#### Risk/Reward Ratio
```
R:R = Average Win / Average Loss

Minimum viable: 1:1
Good: 1.5:1
Excellent: 2:1+

With 50% win rate:
Need 1:1 to break even
Need 1.5:1 for profit
```

#### Maximum Drawdown
```
Largest peak to trough decline
Shows worst-case scenario

Acceptable:
Day traders: <5%
Swing traders: <10%
Position traders: <20%
```

### Performance Tracking
```
Daily tracking:
- P&L ($)
- P&L (%)
- Trades taken
- Win rate
- Average win/loss
- Largest win/loss

Weekly analysis:
- Total return
- Sharpe ratio
- Max drawdown
- Risk/reward
- Mistakes made
```

## Psychological Risk Management

### Emotional Control

#### Fear Management
```
Fear of loss → Stops too tight
Fear of missing out → Bad entries
Fear of being wrong → No stops

Solutions:
- Predefined rules
- Mechanical execution
- Acceptable losses
- Multiple opportunities
```

#### Greed Management
```
Greed signs:
- Increasing leverage
- Larger positions
- Holding too long
- Adding to losers

Control:
- Take partial profits
- Stick to targets
- Regular withdrawals
- Remember losses
```

### Cognitive Biases

#### Confirmation Bias
```
Only seeing supporting evidence
Ignoring contrary signals

Fix:
- Seek opposing views
- Devil's advocate
- Objective criteria
```

#### Recency Bias
```
Overweighting recent events
Last trade influences next

Fix:
- Long-term perspective
- Statistical thinking
- System over emotion
```

## Risk Scenarios

### Scenario Planning

#### Black Swan Preparation
```
Extreme move scenarios:
- 10% flash crash
- 20% overnight gap
- 50% weekly move

Protection:
- Never full leverage
- Diversification
- Stop losses
- Hedging options
```

#### Stress Testing
```
Test your portfolio:
What if BTC drops 30%?
What if funding triples?
What if liquidity dries up?

Calculate:
- Total loss potential
- Margin calls
- Recovery time
```

## Platform-Specific Risks

### Hyperliquid Risks

#### Technical Risks
```
- Network congestion
- Oracle failures
- Smart contract bugs
- Bridge issues

Mitigation:
- Don't oversize
- Multiple platforms
- Regular withdrawals
```

#### Liquidity Risks
```
- Wide spreads in crashes
- Slippage on stops
- Gap risk

Protection:
- Limit orders
- Smaller size in volatility
- Multiple exits
```

## Risk Management Tools

### Position Calculator
```
Inputs:
- Account size
- Risk percentage
- Entry price
- Stop loss

Outputs:
- Position size
- Leverage needed
- Liquidation price
- Risk/reward
```

### Risk Dashboard
```
Monitor:
- Open positions
- Total exposure
- Margin usage
- Liquidation levels
- Portfolio heat
- Correlation risk
```

## Best Practices

### Daily Risk Routine
```
Before trading:
□ Check account balance
□ Review open positions
□ Note key levels
□ Set daily limits
□ Clear mental state

During trading:
□ Follow position sizing
□ Set stops immediately
□ Monitor margin ratio
□ Track portfolio heat
□ Stay disciplined

After trading:
□ Review all trades
□ Calculate metrics
□ Journal lessons
□ Plan improvements
□ Set next day limits
```

### The 10 Commandments of Risk
```
1. Preserve capital above all
2. Never trade without stops
3. Risk small, win consistent
4. Respect leverage always
5. Plan trades, trade plan
6. Accept losses quickly
7. Let winners run
8. Never add to losers
9. Take profits regularly
10. When in doubt, get out
```

## Recovery From Liquidation

### If Liquidated
```
1. Stop immediately
2. Don't revenge trade
3. Analyze what happened
4. Take minimum 48 hours off
5. Review risk management
6. Start tiny when return
7. Rebuild slowly
8. Learn the lesson
```

### Preventing Repeat
```
Changes needed:
- Lower leverage
- Tighter stops
- Smaller positions
- Better planning
- Emotional control
- Rule adherence
```

## Summary

### Risk Management Reality
```
90% of traders lose money
Main reason: Poor risk management
Not lack of strategy

Success requires:
- Discipline
- Patience
- Consistency
- Humility
- Continuous learning

The market will humble you
Respect it or lose everything
```