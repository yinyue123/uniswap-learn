# DeFi Fundamentals & AMM Mechanics

## What Is DeFi?

Decentralized Finance: Financial services without intermediaries, running on smart contracts.

### Traditional Finance vs DeFi
```
Traditional:                DeFi:
You → Bank → Trading       You → Smart Contract → Trading
Bank controls funds         You control funds
Bank sets rules            Code is law
Bank takes profits         You earn fees
```

## Order Book vs AMM

### Order Book (Binance)
```
Buyers place bids, sellers place asks
Match when prices meet
Requires active market makers

Example:
Buy Orders:         Sell Orders:
$49,990 (5 BTC)    $50,010 (3 BTC)
$49,980 (10 BTC)   $50,020 (5 BTC)
Spread: $20
```

### AMM (Uniswap)
```
No order book
Price determined by formula
Liquidity always available

Formula: x × y = k
Pool: 10 ETH × 40,000 USDC = 400,000
Price: 40,000/10 = $4,000 per ETH
```

## The Revolutionary Constant Product Formula

### Core Equation
```
x × y = k

Before trade: x₀ × y₀ = k
After trade:  x₁ × y₁ = k
k must remain constant
```

### How Swaps Work
```
Initial pool: 10 ETH × 40,000 USDC = 400,000 (k)

User swaps 1 ETH for USDC:
New ETH balance: 10 + 1 = 11
New USDC must satisfy: 11 × USDC = 400,000
New USDC = 400,000/11 = 36,363.64
User receives: 40,000 - 36,363.64 = 3,636.36 USDC
```

### Price Impact Calculation
```
Price before: 40,000/10 = 4,000 USDC/ETH
Price after: 36,363.64/11 = 3,305.78 USDC/ETH
Impact: (3,305.78 - 4,000)/4,000 = -17.35%

This is why large trades have high slippage!
```

## Smart Contract Architecture

### Uniswap V2 Core Contracts
```
1. Factory Contract
   - Creates new pairs
   - Tracks all pairs
   - Sets protocol fee

2. Pair Contract (one per pair)
   - Holds reserves
   - Mints/burns LP tokens
   - Executes swaps

3. Router Contract
   - User interface
   - Path finding
   - Slippage protection
```

### Contract Interactions
```
User → Router → Pair → Transfer tokens
         ↓
    Calculate amounts
         ↓
    Check slippage
         ↓
    Execute swap
```

## Gas Fees Explained

### What Is Gas?
```
Gas = Computational units needed
Gas Price = Price per unit (in Gwei)
Total Cost = Gas Used × Gas Price

Example:
Uniswap swap: 120,000 gas
Gas price: 50 Gwei
Cost: 120,000 × 50 = 6,000,000 Gwei = 0.006 ETH
At $2,000/ETH = $12 fee
```

### Gas Optimization
```
Simple swap: ~120,000 gas
Complex route: ~250,000 gas
V3 swap: ~150,000 gas
Adding liquidity: ~175,000 gas
```

## Token Standards

### ERC-20 (Fungible Tokens)
```
Standard functions:
- transfer()
- approve()
- transferFrom()
- balanceOf()
- totalSupply()

Uniswap only works with ERC-20
```

### Token Decimals
```
ETH: 18 decimals
USDC: 6 decimals
WBTC: 8 decimals

Important for calculations:
1 ETH = 1 × 10¹⁸ wei
1 USDC = 1 × 10⁶ units
```

### WETH (Wrapped ETH)
```
Problem: ETH isn't ERC-20
Solution: Wrap ETH → WETH (1:1)

Process:
ETH → WETH contract → WETH token
WETH token → WETH contract → ETH
```

## Liquidity Pools Deep Dive

### Pool Creation
```
First liquidity provider sets initial price
Ratio determines price

Example:
Add 10 ETH + 40,000 USDC
Initial price: 4,000 USDC per ETH
k = 10 × 40,000 = 400,000
```

### LP Tokens
```
Represent share of pool
Formula: LP_tokens = √(x × y)

Initial LP: √(10 × 40,000) = 632.45 LP tokens

Your share = Your LP tokens / Total LP tokens
```

### Fee Distribution
```
Each swap pays 0.3% fee (V2)
Fees stay in pool, increasing k

Example:
Swap 1 ETH, pay 0.003 ETH fee
Pool grows: More value per LP token
```

## Price Discovery Mechanism

### How AMM Sets Prices
```
Price = Reserve_Quote / Reserve_Base

ETH/USDC pool: 10 ETH, 40,000 USDC
ETH price: 40,000 / 10 = $4,000
```

### Arbitrage Keeps Prices Aligned
```
Uniswap: ETH = $3,900
Binance: ETH = $4,000

Arbitrageur:
1. Buy ETH on Uniswap at $3,900
2. Sell on Binance at $4,000
3. Profit: $100 per ETH
4. Repeat until prices align
```

### Slippage Calculation
```
Expected output: Based on current reserves
Actual output: After your trade impacts price
Slippage = (Expected - Actual) / Expected × 100%

Slippage increases with:
- Trade size
- Low liquidity
- Price volatility
```

## Protocol Governance

### UNI Token
```
Total Supply: 1 billion
Distribution:
- 60% Community
- 21.5% Team
- 18.5% Investors

Powers:
- Protocol fee switch
- Treasury management
- Protocol upgrades
```

### Governance Process
```
1. Temperature Check (1M UNI)
2. Consensus Check (10M UNI)
3. Governance Proposal (10M UNI)
4. Voting Period (7 days)
5. Timelock (2 days)
6. Execution
```

## DeFi Composability

### Money Legos
```
Protocols connect like legos:
Aave → Uniswap → Compound → Yearn

Example flow:
1. Borrow USDC from Aave
2. Swap to ETH on Uniswap
3. Deposit ETH to Compound
4. Use cETH in Yearn vault
```

### Flash Loans
```
Borrow without collateral
Must repay in same transaction

Use cases:
- Arbitrage
- Collateral swapping
- Self-liquidation

Example:
1. Borrow 1000 ETH
2. Arbitrage across DEXs
3. Repay 1000 ETH + fee
4. Keep profit
All in one transaction!
```

## Mathematical Models

### Liquidity Depth
```
Liquidity (L) = √(x × y)
Price impact ≈ Trade Size / (2 × L)

Deeper liquidity = Less slippage
```

### Effective Price After Fees
```
Input: 100 USDC
Fee: 0.3%
Effective input: 99.7 USDC
Output calculation uses: 99.7 USDC
```

### Multi-hop Routing
```
No direct ETH/LINK pool?
Route: ETH → USDC → LINK

Gas cost higher but might get better price
Router finds optimal path
```

## Network Effects

### Ethereum Mainnet
```
Pros:
- Highest liquidity
- Most tokens
- Battle-tested

Cons:
- High gas ($10-100)
- Slow (12 seconds)
- Congestion
```

### Layer 2s
```
Polygon:
- Gas: $0.01-0.10
- Speed: 2 seconds
- Liquidity: Medium

Arbitrum:
- Gas: $0.50-5
- Speed: 2 seconds
- Liquidity: High

Optimism:
- Gas: $0.50-5
- Speed: 2 seconds
- Liquidity: Growing
```

## Economic Incentives

### Why Provide Liquidity?
```
1. Earn trading fees (0.3% per swap)
2. Liquidity mining rewards
3. Governance tokens
4. Support projects

ROI = (Fees + Rewards - IL) / Initial Investment
```

### Protocol Revenue
```
V2: 0.3% to LPs (protocol fee off)
V3: Flexible fees (0.01%, 0.05%, 0.3%, 1%)
Protocol can take 10-25% of LP fees
```

## Security Fundamentals

### Smart Contract Risks
```
1. Code bugs
2. Economic exploits
3. Oracle manipulation
4. Governance attacks

Mitigation:
- Audited contracts
- Time-tested protocols
- Gradual exposure
```

### Common Attack Vectors
```
Sandwich Attack:
1. See your transaction
2. Buy before you (front-run)
3. You buy (price rises)
4. Sell after you (back-run)
5. Profit from your slippage
```

## Historical Context

### DeFi Evolution
```
2018: Uniswap V1 (ETH pairs only)
2020: V2 (any pairs), DeFi summer
2021: V3 (concentrated liquidity)
2023: V4 (hooks, customization)
```

### TVL Growth
```
2020: $1B → $20B
2021: $20B → $100B
2022: Bear market, $50B
2023: Recovery to $60B
```

## Key Terminology

**TVL**: Total Value Locked in protocol
**APR**: Annual Percentage Rate (simple interest)
**APY**: Annual Percentage Yield (compound interest)
**IL**: Impermanent Loss
**Slippage**: Difference between expected and executed price
**MEV**: Maximum Extractable Value
**LP**: Liquidity Provider
**AMM**: Automated Market Maker
**DEX**: Decentralized Exchange
**Gwei**: Gas price unit (10⁻⁹ ETH)