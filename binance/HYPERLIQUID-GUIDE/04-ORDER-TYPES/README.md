# Order Types Complete Guide

## Overview of Order Types

Hyperliquid offers sophisticated order types matching professional trading platforms.

### Available Order Types
```
Basic:
- Market Order
- Limit Order

Conditional:
- Stop Market
- Stop Limit
- Take Profit
- Stop Loss

Advanced:
- Post-Only
- Reduce-Only
- IOC (Immediate or Cancel)
- ALO (Add Liquidity Only)
- TWAP (Time-Weighted Average)
```

## Basic Orders

### Market Order

#### How It Works
```
Executes immediately at best available price
Takes liquidity from order book
Guaranteed execution (if liquidity exists)
Pays taker fee (0.025%)
```

#### When to Use
```
✅ Need immediate execution
✅ Breaking news/events
✅ Breakout trading
✅ Stop loss triggered
✅ Closing positions quickly

❌ Large size (slippage)
❌ Thin liquidity
❌ Range-bound markets
```

#### Example Execution
```
Want to buy $10,000 BTC
Order book:
$50,001: 0.05 BTC ($2,500)
$50,002: 0.08 BTC ($4,000)
$50,005: 0.10 BTC ($5,000)

Execution:
Buys all three levels
Average price: $50,003
Slippage: $3
Fee: $2.50 (0.025%)
```

### Limit Order

#### How It Works
```
Sets specific execution price
Waits in order book
May earn maker rebate (-0.02%)
Not guaranteed to fill
```

#### Order Book Placement
```
Your limit buy at $49,950
Current market: $50,000

Order book after:
ASKS
$50,002: 10 BTC
$50,000: 5 BTC
-------
$49,950: YOUR 0.2 BTC ← Waiting here
$49,945: 3 BTC
BIDS
```

#### Advanced Limit Options

##### Post-Only
```
Forces order to be maker
Cancels if would take liquidity
Guarantees rebate or nothing

Use when:
- Want rebate only
- Not urgent
- Providing liquidity
```

##### Reduce-Only
```
Only reduces position size
Cannot increase or flip

Example:
Long 1 BTC
Reduce-only sell 1.5 BTC → Only sells 1 BTC
```

##### Time in Force
```
GTC (Good Till Cancel): Default, stays until filled
IOC (Immediate or Cancel): Fill available, cancel rest
FOK (Fill or Kill): All or nothing
```

## Conditional Orders

### Stop Market Order

#### Mechanism
```
Trigger: Price reaches stop level
Action: Places market order
Execution: At market price

Example:
Current BTC: $50,000
Stop Market Buy: $50,500
If price hits $50,500 → Market buy executes
```

#### Use Cases
```
1. Breakout entry
2. Stop loss exit
3. Trend confirmation
4. Momentum trading
```

#### Stop Loss Example
```
Long position at $50,000
Stop loss at $49,000
If price drops to $49,000:
→ Market sell triggers
→ Position closes
→ Loss limited to $1,000/BTC
```

### Stop Limit Order

#### Mechanism
```
Two prices:
1. Stop price (trigger)
2. Limit price (execution)

More control but risk of non-fill
```

#### Example Setup
```
Current: $50,000
Stop: $49,000
Limit: $48,900

Process:
Price hits $49,000 → Triggers
Limit sell at $48,900 → Placed
Only sells if can get $48,900+
```

#### When to Use
```
✅ Avoid slippage in stop loss
✅ Precise entry points
✅ Less urgent exits
✅ Volatile markets

❌ Must-exit situations
❌ Thin liquidity
❌ Fast markets
```

### Take Profit Order

#### Setup
```
Closes position at profit target
Can be market or limit

Example:
Long from $50,000
Take profit at $52,000
Locks in $2,000/BTC profit
```

#### Partial Take Profit
```
Scale out strategy:
TP1: 25% at $51,000
TP2: 25% at $52,000
TP3: 25% at $53,000
Trail stop: Remaining 25%
```

## Advanced Order Strategies

### OCO (One-Cancels-Other)

#### Concept
```
Two orders linked
One fills, other cancels
Perfect for exits

Example:
Long BTC at $50,000
OCO Setup:
- Take profit: $52,000
- Stop loss: $49,000
Either hits, other cancels
```

### Trailing Stop

#### How It Works
```
Stop follows favorable price
Locks in profits
Never moves against you

Example:
Long at $50,000
Trailing stop: 2% ($1,000)
Price rises to $52,000 → Stop at $50,960
Price rises to $53,000 → Stop at $51,940
Price drops to $51,940 → Executes
```

#### Setting Trail Amount
```
Percentage trail:
- Volatile assets: 3-5%
- Stable assets: 1-2%

Dollar trail:
- Fixed dollar amount
- Better for ranging markets
```

### Iceberg Orders

#### Concept
```
Large order split into smaller visible chunks
Hides true size
Reduces market impact

Example:
Want to buy 10 BTC
Show only 0.5 BTC at a time
Refills as each chunk fills
```

#### Configuration
```
Total size: 10 BTC
Display size: 0.5 BTC
Price: $49,950
Variance: Random 0.4-0.6 BTC

Prevents detection by bots
```

## Order Placement Strategies

### Ladder Orders

#### Buy Ladder
```
Multiple orders at different prices
Averages entry
Reduces timing risk

Example:
$49,900: Buy 0.1 BTC
$49,850: Buy 0.1 BTC
$49,800: Buy 0.1 BTC
Average: $49,850
```

#### Sell Ladder
```
Scale out of position
Multiple profit targets
Maximizes gains

Example:
$50,100: Sell 0.1 BTC
$50,200: Sell 0.1 BTC
$50,300: Sell 0.1 BTC
```

### Grid Trading

#### Setup
```
Range: $49,000 - $51,000
Grid levels: 20
Per level: $100 apart

Buy orders below current
Sell orders above current
Profits from volatility
```

#### Calculation
```
Grid profit per cycle = Spacing - Fees
= $100 - (0.025% × 2 × $50,000)
= $100 - $25
= $75 per round trip
```

## Fee Optimization

### Maker vs Taker

#### Fee Structure
```
Maker: -0.02% (you GET paid!)
Taker: 0.025% (you pay)
Difference: 0.045%

On $100,000 volume:
Maker: Earn $20
Taker: Pay $25
Difference: $45
```

#### Maximizing Rebates
```
1. Use limit orders
2. Post-only flag
3. Don't chase price
4. Be patient
5. Provide liquidity

Monthly earning potential:
$1M volume × 0.02% = $200 rebate
```

### Order Type Selection by Market

#### Trending Markets
```
Use: Market orders for entries
Why: Don't miss the move
Cost: Accept taker fees
Profit: Trend compensates fees
```

#### Ranging Markets
```
Use: Limit orders both sides
Why: Predictable levels
Profit: Collect rebates + ranges
Example: Buy support, sell resistance
```

#### Volatile Markets
```
Use: Stop orders for protection
Why: Quick reversals
Strategy: Wider stops
Cost: More fees but necessary
```

## Order Management

### Modifying Orders

#### What Can Be Changed
```
Unfilled orders:
- Price (moves queue position)
- Size (down only keeps position)
- Cancel entirely

Partially filled:
- Cancel remaining
- Modify remaining size
- Cannot change price
```

#### Queue Position
```
Limit orders have priority:
1. Better price
2. Earlier time (same price)

Modifying price loses position
Reducing size keeps position
```

### Order History

#### Tracking Execution
```
For each order, track:
- Order ID
- Type
- Price
- Size
- Fee/rebate
- Execution time
- Slippage (if market)
```

#### Performance Analysis
```
Calculate:
- Average slippage
- Fee costs
- Rebate earnings
- Fill rates
- Order efficiency
```

## Common Order Mistakes

### Mistake 1: Market Orders in Thin Liquidity
```
Problem: Huge slippage
Example: Market buy $100k in illiquid alt
Result: 5% slippage = $5,000 instant loss

Solution: Use limits or smaller chunks
```

### Mistake 2: Too Tight Stops
```
Problem: Premature exit
Example: 0.5% stop in volatile market
Result: Stopped out, price continues

Solution: ATR-based stops
Stop = Entry ± (2 × ATR)
```

### Mistake 3: Not Using Post-Only
```
Problem: Missing rebates
Example: Limit order takes liquidity
Result: Pay fee instead of earn

Solution: Enable post-only flag
```

### Mistake 4: Forgetting Reduce-Only
```
Problem: Accidental position flip
Example: Short 1 BTC, market buy 2 BTC
Result: Now long 1 BTC unintentionally

Solution: Use reduce-only for exits
```

## Advanced Execution Tactics

### Hidden Orders
```
Not visible in book
Still get maker rebate
Prevents front-running

When to use:
- Large size
- Sensitive levels
- Avoiding detection
```

### Time-Based Execution
```
TWAP (Time-Weighted Average Price):
Execute large order over time
Minimize market impact

Example:
Buy 100 BTC over 1 hour
Split into 60 orders
1.67 BTC per minute
```

### Smart Order Routing
```
Automatically finds best price
Splits across venues
Minimizes slippage

Not yet on Hyperliquid
Coming in future updates
```

## Order Type Selection Guide

### By Strategy

#### Scalping
```
Primary: Limit orders (rebates)
Entry: Post-only limits
Exit: Market or limit
Stop: Tight stop market
```

#### Swing Trading
```
Entry: Limit at support/resistance
Exit: Limit at targets
Stop: Stop market below swing
Trail: For trending moves
```

#### Position Trading
```
Entry: Scaled limit orders
Exit: Scaled take profits
Stop: Wide stop limit
Adjust: Trail monthly
```

### By Market Condition

#### High Volatility
```
Use: Stop limits (not market)
Why: Avoid slippage spikes
Wider: Increase stop distance
Quick: IOC for entries
```

#### Low Volatility
```
Use: Limit orders primarily
Tight: Smaller stop distance
Patient: GTC orders
Grid: Range trading setups
```

#### News Events
```
Before: Set stop losses
During: Market orders only
After: Limit for reversal
Avoid: Complex orders
```

## Best Practices

### Order Checklist
```
Before placing:
□ Check position size
□ Verify order type
□ Confirm price levels
□ Set stop loss
□ Calculate risk
□ Check margin
```

### Daily Routine
```
Morning:
- Cancel stale orders
- Review open orders
- Adjust stops
- Set new levels

Evening:
- Review fills
- Calculate fees
- Note improvements
- Plan tomorrow
```

### Risk Rules
```
1. Always set stop loss
2. Use reduce-only for exits
3. Avoid market orders in thin liquidity
4. Monitor partial fills
5. Cancel outdated orders
6. Track fee costs
7. Optimize for rebates
8. Test new types small
9. Document what works
10. Continuously improve
```