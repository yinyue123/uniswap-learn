# Advanced Strategies & MEV Complete Guide

## What Is MEV?

Maximum Extractable Value: Profit from transaction ordering and blockchain visibility.

### MEV Types
```
Front-running: Execute before target
Back-running: Execute after target
Sandwich: Both front and back
Arbitrage: Price differences
Liquidations: Distressed positions
```

## Sandwich Attacks Explained

### How Sandwiches Work
```
1. See victim's large buy order
2. Buy before them (front-run)
3. Victim buys (price rises)
4. Sell after them (back-run)
5. Profit from price impact

Example:
Victim buying 10 ETH
Attacker buys 5 ETH first
Victim's buy pushes price up 2%
Attacker sells 5 ETH at +2%
Profit: ~0.1 ETH ($400)
```

### Sandwich Math
```
Profit = Victim's Price Impact - Gas Costs - Slippage

Profitable when:
Victim impact > 1%
Trade size > $10,000
Gas reasonable

Typical profit: 0.1-0.5% of victim trade
```

### Protection Methods
```
1. Use MEV protection (Auto)
2. Low slippage (0.1%)
3. Small trades
4. Private mempools
5. Flashbots Protect RPC
```

## Arbitrage Strategies

### Cross-DEX Arbitrage
```
Price Differences:
Uniswap ETH: $4,000
SushiSwap ETH: $4,010

Action:
1. Buy on Uniswap
2. Sell on SushiSwap
3. Profit: $10 per ETH

Reality:
- Gas costs eat profit
- Need large size
- Competition fierce
```

### Triangular Arbitrage
```
Within single DEX:
ETH → USDC → DAI → ETH

If rates misaligned:
1 ETH → 4000 USDC
4000 USDC → 4010 DAI
4010 DAI → 1.005 ETH
Profit: 0.005 ETH
```

### Statistical Arbitrage
```
Mean reversion strategy:
stETH/ETH usually 0.995-1.005

When 0.990:
Buy stETH
Wait for reversion
Sell at 0.998
Profit: 0.8%
```

## Flash Loan Strategies

### What Are Flash Loans?
```
Borrow without collateral
Must repay same transaction
Available amounts: Millions

Providers:
- Aave: 0.09% fee
- dYdX: 0% fee
- Uniswap V3: 0.3% fee
```

### Flash Loan Arbitrage
```
1. Borrow 1000 ETH
2. Exploit price difference
3. Repay 1000 ETH + fee
4. Keep profit

Example:
Borrow 1000 ETH free
Buy token A on DEX1
Sell token A on DEX2 (+1%)
Profit: 10 ETH
```

### Self-Liquidation
```
Position underwater on Aave:
1. Flash loan USDC
2. Repay debt
3. Withdraw collateral
4. Swap to USDC
5. Repay flash loan
6. Keep difference

Saves liquidation penalty!
```

### Flash Loan Attacks
```
Common exploits:
- Oracle manipulation
- Governance attacks
- Reentrancy bugs

Defense:
- Use Chainlink oracles
- Time-weighted prices
- Proper access control
```

## JIT (Just-In-Time) Liquidity

### Concept
```
See large trade coming
Add liquidity just before
Remove right after
Capture majority of fees

Example:
$1M swap incoming
Add $10M liquidity
Capture 90% of fees
Remove liquidity
Profit: $2,700 (0.3% × 90%)
```

### JIT Requirements
```
1. MEV infrastructure
2. High capital
3. Gas optimization
4. Perfect timing
5. Risk tolerance

Profitability:
Revenue: Fee capture
Cost: Gas + IL risk
Net: Often 10-50% APR
```

## Liquidity Sniping

### New Pool Sniping
```
Monitor factory contract
Detect new pool creation
Be first liquidity provider
Set initial price

Profit from:
- Price discovery
- Early fees
- Token appreciation
```

### Migration Sniping
```
V2 → V3 migrations
Old liquidity removes
New liquidity needed
First movers get fees
```

## Cross-Chain Arbitrage

### Bridge Arbitrage
```
ETH on Ethereum: $4,000
ETH on Polygon: $4,020

Strategy:
1. Bridge ETH to Polygon
2. Sell at premium
3. Bridge USDC back
4. Repeat

Costs:
- Bridge fees: $20-50
- Time delay: 10-30 min
- Price risk
```

### Multi-Chain Scanning
```
Monitor prices across:
- Ethereum
- Arbitrum
- Optimism
- Polygon
- BSC

Automated bots execute
When spread > costs
```

## Advanced LP Strategies

### Range Order Strategies
```
Bullish Range Orders:
Place below market
USDC only initially
Converts to ETH on dip
Earn fees while waiting

Example:
Current: $4,000
Range: $3,900-$3,950
Deposit: 10,000 USDC
If filled: Own 2.53 ETH
Plus earned fees
```

### Volatility Farming
```
High volatility = High volume
Volume = Fees

Strategy:
1. Identify volatile pairs
2. Wide ranges to stay in
3. High fee tier (1%)
4. Collect fees from chaos

APR: 100-500% possible
Risk: Extreme IL
```

### Liquidity Laddering
```
Multiple positions:
Position 1: $3,800-4,200 (30%)
Position 2: $3,500-4,500 (30%)
Position 3: $3,000-5,000 (20%)
Position 4: Full range (20%)

Always earning somewhere
Different concentration levels
```

## MEV Protection Strategies

### For Traders

#### Use Private Mempools
```
Flashbots Protect RPC:
https://rpc.flashbots.net

Sends to private pool
No public visibility
No sandwich attacks
Slightly slower
```

#### Smart Slippage Settings
```
Calculate optimal:
Slippage = sqrt(Trade Size / Pool Depth) × 2

Large trade: Use 1-2%
Small trade: Use 0.1-0.5%
New tokens: Use 5-10%
```

#### Transaction Techniques
```
1. Split large trades
2. Use limit orders
3. Trade during high gas
4. Random delays
5. Commit-reveal schemes
```

### For LPs

#### MEV Recycling
```
Some protocols share MEV:
- CowSwap: Solver competition
- 1inch: Fusion mode
- Hashflow: RFQ system

LPs get portion of MEV
Instead of leaked to bots
```

## Bot Development

### Basic Arbitrage Bot
```python
# Pseudocode
while True:
    prices = get_all_dex_prices()
    opportunity = find_arbitrage(prices)

    if opportunity.profit > gas_cost:
        flash_loan = get_flash_loan(opportunity.amount)
        execute_trades(opportunity.path)
        repay_flash_loan()

    wait_next_block()
```

### Infrastructure Needed
```
1. Node access (Alchemy/Infura)
2. MEV infrastructure (Flashbots)
3. Fast execution (Rust/Go)
4. Capital for gas
5. Monitoring system
```

### Competition Reality
```
Professional teams:
- Colocated servers
- Custom hardware
- Direct validator connections
- Millions in capital

Retail chances:
- Long-tail opportunities
- New protocols
- Cross-chain
- Niche strategies
```

## Yield Aggregation

### Automated Compounding
```
Manual: Collect fees, swap, re-add
Auto-compounder: Does it for you

Protocols:
- Beefy Finance
- Yearn
- Harvest

Cost: 4-5% performance fee
Benefit: Gas socialization, automation
```

### Vault Strategies
```
Complex strategies in one token:
1. Deposit USDC
2. Vault deploys to multiple pools
3. Rebalances automatically
4. Compounds yields
5. Manages risk

APY boost: 20-30% typical
```

## Protocol Wars & Incentives

### Liquidity Mining Programs
```
Protocols pay for liquidity:
- UNI rewards
- Trading competitions
- Retroactive airdrops

Strategy:
Farm multiple protocols
Compound rewards
Anticipate migrations
```

### Vote Escrow & Gauges
```
Lock tokens for voting power
Direct emissions to pools
Curve/Balancer model

Strategy:
1. Accumulate governance tokens
2. Lock for max duration
3. Vote for your pools
4. Earn boosted rewards
```

## Tax Optimization Strategies

### Tax Loss Harvesting
```
Sell losers for tax deduction
Immediately rebuy similar asset
No wash sale rule (currently)

Example:
ETH down 30%
Sell ETH, buy stETH
Claim loss, maintain exposure
```

### LP Token Strategies
```
LP tokens may be:
- Property (not taxed until sold)
- Or income (taxed on receipt)

Consult tax professional
Structure accordingly
```

## Risk Management

### Portfolio Construction
```
Allocation:
- 40% Stable LPs (safe income)
- 30% Major pairs (ETH/USDC)
- 20% Arbitrage capital
- 10% Experimental/High risk

Never all in one strategy
```

### Risk Metrics
```
Sharpe Ratio = (Return - Risk Free) / StdDev
Good > 1.5

Max Drawdown: Largest peak to trough
Acceptable < 20%

Value at Risk (VaR): Max loss probability
95% confidence daily VaR < 5%
```

## Future Alpha

### Emerging Opportunities
```
1. Intents & Solvers
2. Cross-chain MEV
3. L2 sequencer races
4. Modular blockchain arb
5. AI-powered strategies
```

### Uniswap V4 Hooks
```
Custom logic on swaps:
- Dynamic fees
- Custom curves
- MEV redistribution
- KYC pools

New strategy space opening
```

## Common Pitfalls

### Overestimating Edge
```
Backtest shows 1000% APR
Reality: 10% after costs
Why: Slippage, competition, gas
```

### Underestimating Costs
```
Forgot to account:
- Gas (can be 50% of profit)
- Slippage
- Failed transactions
- Infrastructure costs
```

### Ignoring Competition
```
Your strategy works today
Tomorrow: 100 bots copying
Next week: No profit

Stay innovative
```

## Professional Tools

### MEV Dashboards
```
- eigenphi.com
- flashbots.net
- mevboost.org
- zeromev.org
```

### Simulation Tools
```
- Tenderly
- Foundry
- Hardhat
- Ganache
```

### Analytics Platforms
```
- Dune Analytics
- Nansen
- Glassnode
- Messari
```

## Ethical Considerations

### Good MEV
```
✅ Arbitrage (improves pricing)
✅ Liquidations (system health)
✅ Back-running (no victim harm)
```

### Bad MEV
```
❌ Sandwich attacks (user harm)
❌ Front-running (theft)
❌ Censorship (network harm)
```

### The Future
```
MEV minimization research:
- Fair ordering
- Threshold encryption
- Commit-reveal schemes
- MEV auctions

Goal: Protect users, maintain efficiency
```

## Getting Started

### Beginner Path
```
1. Understand MEV concepts
2. Use protection as trader
3. Try simple arbitrage
4. Build basic bots
5. Join MEV communities
```

### Required Skills
```
- Solidity basics
- Python/JS for bots
- DeFi understanding
- Risk management
- Fast iteration
```

### Capital Requirements
```
Manual trading: $1,000+
Simple bots: $10,000+
Competitive MEV: $100,000+
Market making: $1,000,000+
```

## Summary

### The MEV Game
```
Zero-sum competition
Winners: Fast, smart, capitalized
Losers: Unprotected users

Your choice:
- Protect yourself (minimum)
- Extract value (advanced)
- Build solutions (expert)
```