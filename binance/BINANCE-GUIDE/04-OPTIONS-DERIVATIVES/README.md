# Options & Derivatives Complete Guide

## Traditional Futures (With Expiry)

### Quarterly Futures
Contracts that expire every 3 months (March, June, Sept, Dec).

```
Contract: BTC-31MAR23
Expiry: March 31, 2023 08:00 UTC
Settlement: Cash (USDT) or Physical (BTC)
```

### Why Use Traditional Futures?
1. **No funding fees** (huge for long-term)
2. **Basis trading** opportunities
3. **Fixed-date hedging**
4. **Tax advantages** (some jurisdictions)

### Contango vs Backwardation
```
Contango: Futures > Spot (normal market)
Example: Spot $50,000, 3-month futures $51,000
Implies: 2% quarterly = 8% annual carry cost

Backwardation: Futures < Spot (shortage/fear)
Example: Spot $50,000, 3-month futures $49,000
Implies: Market expects price decline
```

## Settlement Types

### 1. USDT-Margined (Linear)
```
P&L calculated in USDT
Margin in USDT
Settlement in USDT

Example:
Buy 1 BTC at $50,000
Sell at $52,000
P&L = $2,000 USDT (straightforward)
```

### 2. Coin-Margined (Inverse)
```
P&L calculated in crypto
Margin in crypto
Settlement in crypto

P&L Formula (BTC-margined):
P&L = Contract Size × (1/Entry - 1/Exit)

Example:
Short 10,000 contracts at $50,000
Cover at $45,000
P&L = 10,000 × (1/45,000 - 1/50,000)
P&L = 10,000 × 0.0000222 = 0.222 BTC
```

### Why Coin-Margined Matters
```
When Long + Price Up:
- P&L in BTC (worth more)
- Double win

When Long + Price Down:
- P&L negative in BTC (worth less)
- Double loss

Natural leverage amplification!
```

## Options Trading

### What Are Options?
Right (not obligation) to buy/sell at specific price before expiry.

### Call Options (Right to Buy)
```
Strike: $50,000
Premium: $1,000
Expiry: 30 days

Scenarios:
BTC at $55,000: Exercise, profit = $5,000 - $1,000 = $4,000
BTC at $48,000: Don't exercise, loss = $1,000 premium
```

### Put Options (Right to Sell)
```
Strike: $50,000
Premium: $1,000
Expiry: 30 days

Scenarios:
BTC at $45,000: Exercise, profit = $5,000 - $1,000 = $4,000
BTC at $52,000: Don't exercise, loss = $1,000 premium
```

### Options Greeks

#### Delta (Δ)
Price sensitivity to underlying move
```
Delta = ∂Option Price / ∂Underlying Price

Call Delta: 0 to 1
Put Delta: -1 to 0

Example:
Delta = 0.5
BTC moves $1,000 → Option moves $500
```

#### Gamma (Γ)
Rate of Delta change
```
Gamma = ∂²Option Price / ∂Underlying Price²

High near strike price
Shows acceleration of profits/losses
```

#### Theta (Θ)
Time decay
```
Theta = ∂Option Price / ∂Time

Example:
Theta = -50
Option loses $50 value per day
```

#### Vega (ν)
Volatility sensitivity
```
Vega = ∂Option Price / ∂Volatility

High volatility = Higher premiums
Options buyers want high vega
```

#### Rho (ρ)
Interest rate sensitivity (minimal in crypto)

### Options Strategies

#### 1. Covered Call
```
Own: 1 BTC at $50,000
Sell: Call option, strike $52,000, premium $500

Outcomes:
BTC < $52,000: Keep BTC + $500 premium
BTC > $52,000: Sell BTC at $52,000 + $500
Max profit: $2,500
```

#### 2. Protective Put
```
Own: 1 BTC at $50,000
Buy: Put option, strike $48,000, premium $500

Outcomes:
BTC > $48,000: Loss limited to $500 premium
BTC < $48,000: Protected at $48,000
Insurance cost: $500
```

#### 3. Straddle
```
Buy: Call at $50,000 strike
Buy: Put at $50,000 strike
Total premium: $2,000

Profit if BTC moves > $2,000 either direction
Loss if stays near $50,000
```

#### 4. Iron Condor
```
Sell: Call at $52,000
Buy: Call at $53,000
Sell: Put at $48,000
Buy: Put at $47,000
Net credit: $500

Profit if stays between $48,000-$52,000
Max loss: $500
```

### Black-Scholes Model (Simplified)
```
Call = S×N(d1) - K×e^(-rt)×N(d2)

Where:
S = Spot price
K = Strike price
r = Risk-free rate
t = Time to expiry
N = Cumulative normal distribution

d1 = (ln(S/K) + (r + σ²/2)t) / (σ√t)
d2 = d1 - σ√t
```

## Binance Options Interface

### Option Chain Display
```
Calls                    |  Strike  |                    Puts
Bid   Ask   Vol   OI     |  Price   |     OI   Vol   Ask   Bid
0.05  0.06  100   500     |  45,000  |     200  50   0.01  0.02
0.10  0.11  200   1000    |  50,000  |     800  300  0.10  0.11
0.02  0.03  50    200     |  55,000  |     400  150  0.25  0.26
```

### Options Calculator
```
Input:
- Underlying: $50,000
- Strike: $52,000
- Days to expiry: 30
- Volatility: 80%

Output:
- Premium: $1,500
- Delta: 0.45
- Break-even: $53,500
- Max profit: Unlimited
- Max loss: $1,500
```

## Delivery Mechanisms

### Physical Delivery
```
Contract expires → Actual BTC delivered
Own call at $50,000, BTC at $55,000
→ Receive 1 BTC, pay $50,000
```

### Cash Settlement
```
Contract expires → USDT profit/loss
Own call at $50,000, BTC at $55,000
→ Receive $5,000 USDT
```

### Auto-Exercise
```
ITM options auto-exercise at expiry
Unless manually abandoned
Prevents forgetting profitable positions
```

## Advanced Derivatives

### 1. Leveraged Tokens
```
Token: BTCUP (3x Long BTC)
Rebalances daily to maintain 3x

If BTC +10% → BTCUP +30%
If BTC -10% → BTCUP -30%

Warning: Volatility decay
BTC: +10%, -9.09% = 0% net
BTCUP: +30%, -27.27% = -5.45% net
```

### 2. Volatility Products
```
Buy volatility when expecting big moves
Sell volatility when expecting calm

VIX equivalent for crypto
Based on options implied volatility
```

### 3. Structured Products
```
Dual Investment:
Deposit: 1 BTC
Strike: $55,000
Yield: 20% APY

If BTC > $55,000: Get USDT at strike
If BTC < $55,000: Keep BTC + yield
```

## Risk Calculations

### Maximum Loss Scenarios

#### Long Options
```
Max Loss = Premium Paid
Cannot lose more than initial cost
```

#### Short Options
```
Naked Call: Max Loss = Unlimited
Naked Put: Max Loss = Strike Price - Premium
Covered: Max Loss = Underlying loss - Premium
```

### Position Greeks
```
Portfolio Delta = Σ(Position Size × Delta)
Tells overall directional exposure

Example:
+1 BTC spot: Delta = +1
-2 Call options, Delta 0.5 each: Delta = -1
Net Delta = 0 (market neutral)
```

### Margin Requirements

#### Options Selling
```
Call Margin = max(0.15 × Underlying - OTM Amount, 0.1 × Underlying)
Put Margin = max(0.15 × Strike - OTM Amount, 0.1 × Strike)

Example:
Sell BTC call, strike $55,000, spot $50,000
Margin = max(0.15 × 50,000 - 5,000, 0.1 × 50,000)
Margin = max(2,500, 5,000) = $5,000
```

## Calendar Spreads

### Futures Calendar Spread
```
Long: June futures at $51,000
Short: March futures at $50,500
Profit: If spread widens
Risk: Limited to spread difference
```

### Roll Strategy
```
Position in March futures
March approaching expiry
Close March, open June
Cost: Roll spread + fees
```

## Practical Examples

### Hedging Mining Operation
```
Mine: 10 BTC/month
Cost: $30,000/BTC
Hedge: Sell 10 BTC futures at $50,000

Outcome:
If BTC drops to $40,000:
- Mining profit: $10,000/BTC
- Futures profit: $10,000/BTC
- Total: $20,000/BTC locked in
```

### Earnings Play
```
Major announcement coming
Buy straddle:
- Call at $50,000: $1,000
- Put at $50,000: $1,000

Need > 4% move to profit
Big news = Big move = Profit
No news = No move = Loss
```

### Yield Enhancement
```
Own: 100 BTC
Sell: Monthly calls 10% OTM
Premium: 2% monthly = 24% annually

Risk: Capped upside
Reward: Income in sideways market
```

## Common Pitfalls

### 1. Assignment Risk
```
Short call, BTC moons
Assigned early (American style)
Must deliver BTC you don't have
Emergency market buy at loss
```

### 2. Liquidity Issues
```
Wide bid-ask spreads
Can't exit at fair price
Especially in panic

Solution: Stick to liquid strikes
```

### 3. Pin Risk
```
Expiry exactly at strike
Uncertain if ITM or OTM
Auto-exercise confusion

Solution: Close before expiry
```

### 4. Volatility Crush
```
Buy options before event
Event happens, volatility drops
Option value crushed despite being right

Solution: Sell volatility after events
```

## Tax Considerations

### Options Taxation
- Premium received: Income when expires
- Premium paid: Deductible when expires
- Exercise: Adjust basis of underlying
- Each strategy has different treatment

### Futures Taxation
- Mark-to-market daily (some jurisdictions)
- 60/40 rule (60% long-term, 40% short-term)
- Section 1256 contracts in US

### Record Requirements
```
For each trade:
- Contract specifications
- Entry/exit dates
- Premiums paid/received
- Exercise/assignment details
- P&L in fiat terms
- Margin posted
```

## Platform-Specific Features

### Binance Options
- European style (exercise at expiry only)
- T+0 settlement
- Portfolio margin available
- Options on BTC and ETH only

### Order Types
- Limit orders only
- No market orders
- GTC or IOC
- Maker rebates available

### Position Limits
```
Account Type | Options | Futures
Basic        | 100     | 500
VIP 1        | 500     | 2,000
VIP 2        | 1,000   | 5,000
VIP 3        | 5,000   | 20,000
```

## Risk Management Framework

### Kelly Criterion for Options
```
f = (p×b - q) / b
f = fraction to risk
p = win probability
b = win/loss ratio

Example:
60% win rate, 2:1 payoff
f = (0.6×2 - 0.4) / 2 = 0.4
Risk 40% of capital (too high, use 1/4 Kelly)
```

### Portfolio VaR
```
VaR = Portfolio Value × Volatility × Z-score × √Time

95% confidence, 1-day VaR:
VaR = $100,000 × 0.04 × 1.65 × 1
VaR = $6,600 potential loss
```

## Getting Started Safely

### Learning Path
1. **Month 1**: Paper trade options, understand Greeks
2. **Month 2**: Small covered calls/puts
3. **Month 3**: Spreads with defined risk
4. **Month 6**: Complex strategies
5. **Never**: Naked selling without experience

### Position Sizing
```
Options buying: Max 5% per trade
Options selling: Max 20% margin usage
Futures: Start with 1x, earn higher
Never: All-in on any derivative
```

### Tools Required
- Options calculator
- Greeks monitor
- Volatility tracker
- P&L simulator
- Risk dashboard