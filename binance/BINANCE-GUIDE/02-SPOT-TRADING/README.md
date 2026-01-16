# Spot Trading Complete Guide

## What Is Spot Trading?

Immediate exchange of cryptocurrencies at current market prices. You own the actual asset.

```
Spot Trade: You pay $50,000 → You own 1 BTC
Not Like Futures: You pay $5,000 margin → Control $50,000 BTC position
```

## The Order Book Explained

### Structure
```
         SELL ORDERS (ASKS)
    Price    Size    Total
    50,010   2.5     125,025
    50,005   1.2     60,006
    50,002   0.8     40,002
    =====================
    SPREAD: $2
    =====================
    50,000   1.0     50,000    <- Best Bid
    49,995   1.5     74,993
    49,990   3.0     149,970
         BUY ORDERS (BIDS)
```

### What This Means
- **Bids**: People wanting to buy
- **Asks**: People wanting to sell
- **Spread**: Difference between best bid/ask
- **Depth**: Total volume at each level

### Why Order Book Matters
1. **Liquidity assessment**: Thick book = easy trades
2. **Support/resistance**: Large walls = price barriers
3. **Whale watching**: Spot large orders
4. **Slippage prediction**: Estimate market impact

## Order Types Deep Dive

### 1. Market Order
**Logic**: "Buy/Sell NOW at ANY price"
```
You want: Buy 5 BTC
Order book has: 2 BTC at $50,000, 3 BTC at $50,010
You pay: (2×50,000) + (3×50,010) = $250,030
Average price: $50,006
```

**When to use**:
- Need immediate execution
- Small amounts
- High volatility (catching moves)

**Risks**:
- Slippage in thin markets
- Front-running by bots
- Paying premium

### 2. Limit Order
**Logic**: "Buy/Sell ONLY at this price or better"
```
Current price: $50,000
Your limit buy: $49,500
Result: Order sits in book until price drops
```

**Advanced Limit Options**:
- **Post-Only**: Ensures maker fee (cancels if would take)
- **Fill or Kill (FOK)**: All or nothing, immediate
- **Immediate or Cancel (IOC)**: Fill what's available, cancel rest

### 3. Stop-Loss Order
**Logic**: "If price hits X, create market sell"
```
You own 1 BTC at $50,000
Stop-loss at: $49,000
If price drops to $49,000 → Market sell triggers
```

**Hidden mechanism**:
1. Order not in book (hidden)
2. Monitors price constantly
3. Triggers market order when hit
4. Execution not guaranteed at stop price

### 4. Stop-Limit Order
**Logic**: "If price hits X, create limit order at Y"
```
Trigger: $49,000
Limit: $48,900
Process: Price hits $49,000 → Places sell at $48,900
Risk: Might not fill if drops too fast
```

### 5. OCO (One-Cancels-Other)
**Logic**: Two orders, one fills, other cancels
```
Current BTC: $50,000
OCO Setup:
- Limit sell: $52,000 (take profit)
- Stop-limit: $49,000 (stop loss)
Either fills → Other cancels
```

### 6. Trailing Stop
**Logic**: Stop follows price up, locks in profits
```
Buy at: $50,000
Trailing: 2%
Price rises to $52,000 → Stop at $50,960
Price rises to $53,000 → Stop at $51,940
Price drops to $51,940 → Sells
```

## Fee Structure Detailed

### Basic Formula
```
Trading Fee = Order Value × Fee Rate × (1 - Discount)
```

### Fee Tiers (Spot)
| Level | 30d Volume | Maker | Taker |
|-------|------------|--------|--------|
| VIP 0 | <$1M | 0.10% | 0.10% |
| VIP 1 | >$1M | 0.09% | 0.10% |
| VIP 2 | >$5M | 0.08% | 0.10% |
| VIP 3 | >$10M | 0.07% | 0.09% |

### BNB Discount
- Pay fees in BNB: 25% discount
- Example: 0.10% becomes 0.075%

### Maker vs Taker
```
Maker: Adds liquidity (limit order that doesn't fill immediately)
Taker: Removes liquidity (market order or aggressive limit)

Example:
Book best ask: $50,000
Your limit buy at $49,999 = Maker (adds to book)
Your limit buy at $50,000 = Taker (matches immediately)
```

### Real Cost Calculation
```
Buy 1 BTC at $50,000:
- Taker fee: $50,000 × 0.001 = $50
- With BNB: $50,000 × 0.00075 = $37.50
- Round trip (buy+sell): $75-$100
```

## Interface Functions Explained

### Trading View Components

#### 1. Chart Types
- **Candlestick**: OHLC data (most info)
- **Line**: Closing prices only
- **Depth**: Order book visualization
- **Volume Profile**: Volume at price levels

#### 2. Technical Indicators
**Moving Averages (MA)**
```
MA(n) = (P1 + P2 + ... + Pn) / n
Use: Trend identification
```

**RSI (Relative Strength Index)**
```
RSI = 100 - (100 / (1 + RS))
RS = Average Gain / Average Loss
Use: Overbought (>70) / Oversold (<30)
```

**MACD**
```
MACD = 12-day EMA - 26-day EMA
Signal = 9-day EMA of MACD
Use: Momentum shifts
```

#### 3. Drawing Tools
- **Trend lines**: Support/resistance
- **Fibonacci**: Retracement levels
- **Channels**: Price ranges

### Order Panel

#### Basic Mode
- Simple buy/sell
- Amount input
- Market/Limit toggle

#### Advanced Mode
```
[Order Type ▼] [Limit Price] [Amount] [Total]
[Stop Price] [Limit Price] <- For stop-limit
[√ Post-Only] [√ Reduce-Only]
[Time in Force ▼]
```

#### Time in Force Options
- **GTC** (Good Till Cancel): Stays until filled/cancelled
- **IOC** (Immediate or Cancel): Fill available, cancel rest
- **FOK** (Fill or Kill): All or nothing

### Position Panel

Shows:
```
Asset | Amount | Avg Price | Current | P&L | P&L%
BTC   | 1.5    | $49,500   | $50,000 | $750 | +1.01%
```

### Trade History
```
Time | Pair | Type | Price | Amount | Fee | Total
```

## Advanced Concepts

### 1. Market Making
```
Strategy: Place buy and sell limits around price
Buy at: $49,990
Sell at: $50,010
Profit per cycle: $20 - fees
Risk: Inventory imbalance
```

### 2. Dollar Cost Averaging (DCA)
```
Investment: $1000/month
Month 1: Buy at $50,000 = 0.02 BTC
Month 2: Buy at $45,000 = 0.022 BTC
Month 3: Buy at $55,000 = 0.018 BTC
Average: $49,180 per BTC
```

### 3. Arbitrage
```
Binance BTC: $50,000
Coinbase BTC: $50,100
Arbitrage: Buy Binance, Transfer, Sell Coinbase
Profit: $100 - fees - transfer time risk
```

### 4. Volume Analysis
```
Price Up + Volume Up = Strong bullish
Price Up + Volume Down = Weak rally
Price Down + Volume Up = Strong bearish
Price Down + Volume Down = Weak selloff
```

## Risk Management

### Position Sizing
```
Kelly Criterion: f = (bp - q) / b
f = fraction to bet
b = odds (profit/loss ratio)
p = probability of win
q = probability of loss

Simplified: Risk 1-2% per trade
```

### Stop Loss Placement
```
ATR Method: Stop = Entry - (2 × ATR)
Percentage: Stop = Entry × (1 - Risk%)
Support: Stop below key level
```

### Risk/Reward Ratio
```
RRR = Potential Profit / Potential Loss
Good trade: RRR > 2:1

Example:
Entry: $50,000
Stop: $49,000 (risk $1000)
Target: $52,000 (reward $2000)
RRR = 2:1
```

## Common Patterns & What They Mean

### 1. Pump and Dump
```
Phase 1: Accumulation (sideways)
Phase 2: Pump (vertical rise)
Phase 3: Distribution (top)
Phase 4: Dump (vertical fall)
```

### 2. Bart Pattern
```
    ____
   |    |
___|    |___

Sudden spike up/down, return to start
Cause: Large market order + low liquidity
```

### 3. Whale Walls
```
Large sell wall at $50,000 (100 BTC)
Means:
- Resistance (if real)
- Suppression (if fake)
- Accumulation zone below
```

## Tax Implications

### Taxable Events
1. **Crypto → Fiat**: Always taxable
2. **Crypto → Crypto**: Taxable in most countries
3. **Buying**: Not taxable
4. **Receiving** (mining/staking): Income tax

### Record Keeping
```
For each trade:
- Date & Time
- Asset pair
- Amount
- Price in fiat
- Fees
- Platform
```

## Platform-Specific Features

### Convert (Simple Swap)
- One-click conversion
- No order book
- Higher fees (~0.5% spread)
- Good for beginners

### Auto-Invest (DCA Bot)
- Scheduled purchases
- Multiple assets
- Rebalancing options
- Fee: Same as spot

### Copy Trading
- Follow experienced traders
- Proportional position sizing
- Risk: Delayed execution

## Troubleshooting

### Order Won't Fill
1. Price moved away
2. Not enough liquidity
3. Post-only rejected
4. Minimum order size not met

### Unexpected Fees
1. Used market order (taker fee)
2. No BNB for discount
3. Hidden spread in convert

### Missing Funds
1. Check all wallets (Spot/Funding/Earn)
2. Check open orders
3. Check trade history
4. Check withdrawal history

## Pro Tips

1. **Always use limit orders** when possible
2. **Keep BNB** for fee discount
3. **Don't chase** pumps
4. **Set stops** before bed
5. **Journal trades** for improvement
6. **Use testnet** first
7. **Start small** scale gradually
8. **Watch funding** wallet for airdrops