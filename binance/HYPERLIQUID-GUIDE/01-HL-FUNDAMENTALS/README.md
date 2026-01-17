# Hyperliquid L1 Fundamentals

## What Is Hyperliquid?

A fully on-chain perpetual futures DEX built on its own L1 blockchain, offering CEX-like performance with DEX transparency.

### The Architecture
```
Traditional DEX: App → Ethereum → Smart Contract → Slow
Hyperliquid: App → HL L1 → Native Execution → Fast

Result:
- No gas fees for trading
- Sub-second execution
- Full on-chain transparency
- Self-custody always
```

## Hyperliquid L1 Explained

### Why Own Blockchain?
```
Problems with Ethereum DEXs:
- High gas costs ($20-100/trade)
- Slow execution (12+ seconds)
- MEV attacks
- Limited throughput

HL L1 Solution:
- Zero gas trading
- 20,000+ TPS capacity
- No MEV possible
- Instant finality
```

### Technical Specifications
```
Consensus: Tendermint-based
Block Time: <1 second
Throughput: 20,000+ orders/second
Validators: Permissioned (currently)
State: Fully deterministic
```

### The Stack
```
Layer 4: UI/Apps
Layer 3: API/SDK
Layer 2: Matching Engine
Layer 1: HL Blockchain
Layer 0: Validator Network
```

## Order Book vs AMM

### Order Book (Hyperliquid/Binance)
```
Buyers and sellers place specific orders
Price discovery through bid/ask
Professional market making

Example Order Book:
ASKS (Sells)
$50,010 | 2.5 BTC
$50,005 | 1.8 BTC
$50,002 | 0.5 BTC
------- SPREAD -------
$50,000 | 0.8 BTC
$49,995 | 1.2 BTC
$49,990 | 3.0 BTC
BIDS (Buys)
```

### AMM (Uniswap)
```
No order book
Price from x*y=k formula
Anyone can provide liquidity
Always available liquidity
Higher slippage on size
```

### Why Order Book for Perps?
```
Advantages:
- Precise price execution
- Limit orders possible
- No impermanent loss
- Professional liquidity
- Tighter spreads

Perfect for derivatives
```

## The Matching Engine

### How Orders Match
```
1. Order arrives
2. Check against book
3. Match if crossable
4. Update state
5. Confirm execution

All in <200ms
```

### Price-Time Priority
```
Orders matched by:
1. Best price first
2. Earlier time if same price

Example:
Order A: Buy at $50,000 (10:00:00)
Order B: Buy at $50,000 (10:00:01)
Order A fills first
```

### Order Types Available
```
Market: Execute immediately
Limit: Execute at price or better
Stop Market: Trigger market order
Stop Limit: Trigger limit order
Take Profit: Close at profit
Stop Loss: Close at loss
```

## Liquidation Engine

### How Liquidations Work
```
Position monitoring → Margin check → Trigger → Liquidate

Hyperliquid Specific:
- Atomic liquidations (instant)
- No auction period
- Direct to HLP vault
- Zero slippage
```

### Liquidation Formula
```
Margin Ratio = (Margin + Unrealized P&L) / Position Notional

When Margin Ratio < Maintenance Margin:
→ Instant liquidation
→ Position closed at mark price
→ Remaining margin to insurance fund
```

### Insurance Fund
```
Protects system from bad debt
Funded by:
- Liquidation remainders
- Trading fees portion
- HLP profits

Current size: $XX million
```

## HLP (Hyperliquid Liquidity Provider)

### What Is HLP?
```
The vault that provides liquidity
Takes other side of trades
Earns fees and liquidations
Bears trader P&L risk

Similar to:
- GLP on GMX
- Pool on dYdX
```

### HLP Mechanics
```
Deposit USDC → Get HLP shares
HLP acts as counterparty
Earns from:
- Trading fees
- Liquidations
- Funding rates

Loses from:
- Trader profits
```

### Returns Calculation
```
HLP APR = Fees + Liquidations - Net Trader P&L

Example:
Daily fees: $1M
Daily liquidations: $200k
Trader profits: $800k
Net daily: $400k
If HLP = $100M, daily return = 0.4%
Annualized: 146% APR
```

## Bridge System

### Supported Bridges
```
From Arbitrum:
- USDC native
- ~10 min transfer
- $1-5 cost

Process:
Arbitrum USDC → Bridge Contract → HL L1 USDC
```

### Bridge Security
```
Multi-sig controlled
Time delays on large amounts
Regular audits
Insurance fund backing
```

### Deposit/Withdrawal
```
Deposits:
- Minimum: $10
- Maximum: No limit
- Time: 10-30 minutes

Withdrawals:
- Minimum: $10
- Maximum: Daily limits apply
- Time: 10-60 minutes
- Fee: Network costs only
```

## Points System

### How Points Work
```
Earn points for:
- Trading volume
- Providing HLP liquidity
- Referring users
- Early adoption

Points likely convert to tokens
Similar to dYdX model
```

### Points Calculation
```
Trading Points = Volume × Multiplier × Time Factor

Example:
Trade $100k/day × 1.5x multiplier × 30 days
= 4.5M points

HLP Points = TVL × Time × Multiplier
```

## Fee Structure

### Trading Fees
```
Maker: -0.02% (you GET paid!)
Taker: 0.025%
Referral discount: 10%

Example:
$100k limit order filled
You receive: $20 rebate

$100k market order
You pay: $25 fee
```

### Why Negative Maker Fees?
```
Incentivizes liquidity
Tighter spreads
Better price discovery
Competes with CEXs
Funded by taker fees
```

### Funding Rates
```
Paid hourly (not 8-hour)
Balances long/short interest
Can be positive or negative

Example:
0.01% per hour = 0.24% daily
Longs pay shorts if positive
```

## Vault System

### Vault Types
```
1. HLP Vault (system liquidity)
2. User Vaults (copy trading)
3. Strategy Vaults (automated)

Anyone can create vault
Investors can join/leave
Performance fees only
```

### Vault Mechanics
```
Vault creator trades
Investors mirror trades
Proportional to investment
Creator earns performance fee

Example:
Vault makes 20% profit
10% performance fee
Creator earns 2% of AUM
```

## The Order Book Advantage

### For Traders
```
✅ Exact price execution
✅ No slippage on limits
✅ See liquidity depth
✅ Professional spreads
✅ Complex order types
```

### For Market Makers
```
✅ Precise control
✅ Rebates on makes
✅ Inventory management
✅ API integration
✅ Competitive edge
```

## Network Security

### Validator Set
```
Currently permissioned
Plans for decentralization
Validators run nodes
Consensus on all trades
Cannot censor transactions
```

### State Verification
```
All trades on-chain
Verifiable by anyone
Cannot be reversed
Transparent liquidations
Auditable positions
```

## Comparing DEX Models

### Hyperliquid Model
```
Pros:
- CEX-like experience
- No gas fees
- Fast execution
- Professional features

Cons:
- Centralized validators (for now)
- Bridge dependency
- Limited assets
```

### Uniswap Model
```
Pros:
- Fully decentralized
- Any token possible
- No bridges needed
- Proven security

Cons:
- High gas costs
- Slow execution
- Impermanent loss
- Limited order types
```

### dYdX Model
```
Pros:
- Decentralized
- Good liquidity
- Established platform

Cons:
- StarkEx complexity
- Migration to Cosmos
- Higher fees than HL
```

## Economic Model

### Revenue Sources
```
Platform earnings from:
1. Trading fees (taker)
2. Liquidation fees
3. Bridge fees
4. Future token value

Distribution:
- HLP providers
- Validators
- Treasury
- Token holders (future)
```

### Sustainability
```
Current metrics:
- Daily volume: $100M-1B
- Daily fees: $25k-250k
- Profitable operation
- Growing user base
```

## Risk Factors

### Platform Risks
```
1. Smart contract bugs
2. Bridge vulnerabilities
3. Validator issues
4. Regulatory changes
5. Competition

Mitigation:
- Audits ongoing
- Insurance fund
- Gradual rollout
- Compliance focus
```

### Systemic Risks
```
1. Mass liquidations
2. HLP drawdown
3. Oracle failures
4. Network attacks

Protections:
- Circuit breakers
- Position limits
- Multiple price feeds
- Rate limiting
```

## Future Roadmap

### Near Term (3-6 months)
```
- Token launch
- Spot trading
- More assets
- Mobile app
- Validator decentralization
```

### Long Term (6-12 months)
```
- Options trading
- Lending markets
- Cross-chain bridges
- Institutional features
- Full decentralization
```

## Why Hyperliquid Matters

### Innovation Points
```
1. First successful perps DEX
2. Solved the speed problem
3. No gas fee trading
4. Sustainable economics
5. Real CEX competitor
```

### Market Position
```
Growing market share:
- From CEX refugees
- DeFi natives
- New traders

Advantages:
- No KYC
- Self-custody
- Transparent
- Performant
```

## Getting Started Tips

### Prerequisites
```
1. Understand perpetuals
2. Know liquidation risks
3. Have risk management
4. Start small
5. Learn the interface
```

### Common Mistakes
```
❌ Using max leverage immediately
❌ No stop losses
❌ Ignoring funding rates
❌ Overtrading
❌ FOMO entries
```

### Success Factors
```
✅ Consistent risk management
✅ Understanding market structure
✅ Using limit orders
✅ Monitoring positions
✅ Continuous learning
```