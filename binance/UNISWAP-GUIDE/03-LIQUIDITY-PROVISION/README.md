# Liquidity Provision (V2) Complete Guide

## What Is Liquidity Provision?

You deposit token pairs into pools, enabling others to trade while you earn fees.

### The Business Model
```
You provide: 1 ETH + 4,000 USDC
Pool uses for: Trading
You earn: 0.3% of every swap
Risk: Impermanent loss
```

## How V2 Pools Work

### Constant Product Formula
```
x × y = k

Your liquidity spreads from 0 to ∞
Always 50/50 value ratio
Automatically rebalances
```

### Creating a New Pool
```
Requirements:
- First depositor sets price
- Must add both tokens
- Ratio determines initial price

Example:
Add: 10 ETH + 40,000 USDC
Sets: 1 ETH = 4,000 USDC
```

### Adding to Existing Pool
```
Must match current ratio
Pool: 100 ETH + 400,000 USDC
Ratio: 1:4000

To add 1 ETH, need 4,000 USDC
Cannot add single-sided
```

## LP Token Mathematics

### LP Token Minting
```
First deposit:
LP_minted = √(amount0 × amount1)

Subsequent deposits:
LP_minted = min(
    amount0 × totalSupply / reserve0,
    amount1 × totalSupply / reserve1
)
```

### Real Example
```
Initial deposit:
10 ETH + 40,000 USDC
LP tokens = √(10 × 40,000) = 632.45

Second depositor adds:
1 ETH + 4,000 USDC
LP tokens = 1 × 632.45 / 10 = 63.245

Total LP supply: 695.695
Your share: 63.245 / 695.695 = 9.09%
```

### LP Token Value
```
Value = (Total Pool Value × Your LP Tokens) / Total LP Supply

Pool: 11 ETH + 44,000 USDC ($88,000)
Your share: 9.09%
Your value: $8,000
```

## Fee Earnings Calculation

### How Fees Accumulate
```
Every swap pays 0.3%
Fees stay in pool
Increases value per LP token

Example:
Daily volume: $1,000,000
Daily fees: $3,000
Your 10% share: $300/day
APR: $300 × 365 / $10,000 = 1,095%
```

### Compound Effect
```
Fees reinvest automatically
Pool grows: 100 ETH → 101 ETH
k increases: More liquidity
Your LP tokens worth more
```

### Real Yield Calculation
```
APR = (Daily Fees × 365) / TVL × Your Share

High volume pairs:
- ETH/USDC: 20-50% APR
- ETH/WBTC: 15-30% APR

Low volume pairs:
- Random tokens: 0-5% APR
```

## Step-by-Step: Adding Liquidity

### 1. Navigate to Pool
```
app.uniswap.org → Pool → Add Liquidity
Choose V2
Select token pair
```

### 2. Check Pool Stats
```
Look for:
- TVL (Total Value Locked)
- 24h Volume
- 24h Fees
- APR estimate

Good pool:
- TVL > $1M
- Volume/TVL > 0.5
- Stable APR history
```

### 3. Input Amounts
```
Enter one token amount
Other auto-calculates
Must maintain ratio

Example:
Enter: 1 ETH
Auto-fills: 3,995 USDC
(Based on current price)
```

### 4. First-Time Setup
```
1. Approve Token A (one-time)
2. Approve Token B (one-time)
3. Add liquidity

Gas costs:
- Each approval: ~45,000 gas
- Add liquidity: ~175,000 gas
Total first time: ~265,000 gas ($50-150)
```

### 5. Transaction Confirmation
```
Review shows:
- Share of pool: 0.05%
- LP tokens received: 125.5
- Rates: 1 ETH = 3,995 USDC

Confirm in wallet
Wait for confirmation
```

### 6. Verify Position
```
Go to "Pool" tab
See your positions
Shows:
- Pool composition
- Your share
- Accrued fees
- Current value
```

## Position Management

### Monitoring Your Position
```
Track daily:
- Pool balance changes
- Fee accumulation
- Impermanent loss
- Total return

Key metrics:
- Initial value: $10,000
- Current value: $10,500
- Fees earned: $800
- IL: -$300
- Net return: +$500 (5%)
```

### When to Add More
```
Good times:
- After big price swings (IL realized)
- High volume periods
- Low gas costs
- Balanced ratio

Bad times:
- Before big moves
- Low volume
- High gas
- Extreme ratios
```

### Removing Liquidity

#### Full Withdrawal
```
Pool → Your positions → Remove
Slider to 100%
Receive both tokens proportionally

Example:
LP tokens: 100
Pool: 120 ETH + 360,000 USDC
Your share: 10%
Receive: 12 ETH + 36,000 USDC
```

#### Partial Withdrawal
```
Remove 50% liquidity
Keep earning on remainder
Good for:
- Taking profits
- Rebalancing
- Reducing exposure
```

## Fee Strategies

### High Volume Pairs
```
ETH/USDC, ETH/USDT
Pros:
- High fees (50-200% APR possible)
- Deep liquidity
- Less manipulation

Cons:
- High competition
- Smaller share of pool
- IL risk remains
```

### Stable Pairs
```
USDC/USDT, DAI/USDC
Pros:
- Minimal IL (<0.1%)
- Predictable returns
- Safe for beginners

Cons:
- Lower APR (5-20%)
- Needs large capital
- Boring but steady
```

### Correlated Pairs
```
ETH/stETH, WBTC/renBTC
Pros:
- Low IL (tokens move together)
- Decent APR (10-30%)
- Specialized demand

Cons:
- Smart contract risk
- Peg risk
- Lower volume
```

## Risk Assessment

### Impermanent Loss Preview
```
Price change | IL
-------------|-------
1.25x        | 0.6%
1.5x         | 2.0%
2x           | 5.7%
3x           | 13.4%
4x           | 20.0%
5x           | 25.5%

IL happens when price ratio changes!
```

### Smart Contract Risk
```
V2 Risks:
- Battle-tested since 2020
- $3B+ TVL historically
- Multiple audits
- Still possible bugs

Mitigation:
- Don't deposit life savings
- Diversify protocols
- Monitor news
```

### Rug Pull Risk
```
New token pools:
- Token can be minted infinitely
- Dev dumps on your liquidity
- You're left with worthless tokens

Protection:
- Only verified tokens
- Check contract
- Start small
- Watch for red flags
```

## Advanced Strategies

### LP as Collateral
```
Platforms accepting LP tokens:
- Abracadabra (MIM)
- Unit Protocol
- Rari Fuse

Strategy:
1. Provide liquidity
2. Deposit LP tokens
3. Borrow stablecoins
4. Earn on both sides
```

### Liquidity Mining
```
Extra rewards beyond fees:
Some pools offer:
- Governance tokens
- Protocol incentives
- Partner rewards

Example:
Base APR: 30% (fees)
Mining rewards: 50% (tokens)
Total APR: 80%
```

### Delta Neutral LP
```
Problem: Don't want price exposure
Solution: Hedge with perps

Setup:
1. LP 1 ETH + 4,000 USDC
2. Short 0.5 ETH on perps
3. Neutral to ETH price
4. Earn fees without direction risk
```

### LP Laddering
```
Split capital across ranges:
- 30% in ETH/USDC
- 30% in ETH/USDT
- 20% in ETH/DAI
- 20% in stablecoin pairs

Benefits:
- Diversified risk
- Multiple fee sources
- Different IL profiles
```

## Tax Considerations

### LP Token Treatment
```
Adding liquidity: Not taxable (usually)
Removing liquidity: Taxable event
Earning fees: Income tax

Complex because:
- Token ratios change
- Need to track cost basis
- Fees compound inside
```

### Record Keeping
```
Track for each position:
- Date added
- Tokens/amounts deposited
- USD value at entry
- LP tokens received
- Date removed
- Tokens/amounts received
- USD value at exit
```

## Common Mistakes

### 1. Ignoring Gas Costs
```
Small position: $500
Gas to enter: $100
Gas to exit: $80
Need 36% gain to break even!

Solution: Minimum $5,000 positions
```

### 2. Chasing APR
```
See 1,000% APR
Jump in without research
Pool dries up next day
Stuck with IL and no fees

Solution: Check history, sustainability
```

### 3. Wrong Pair Selection
```
Provide ETH/SHITCOIN
SHITCOIN dumps 90%
Massive IL
Left holding bags

Solution: Quality tokens only
```

### 4. Panic Removing
```
See IL at -10%
Remove liquidity immediately
Miss fee earnings
Realize permanent loss

Solution: Long-term view
```

## V2 vs V3 Decision

### When to Use V2
```
✅ Passive management wanted
✅ Long-term holding
✅ New to LP
✅ Volatile pairs
✅ Small positions

Full range = Set and forget
```

### When to Use V3
```
✅ Active management
✅ Stable pairs
✅ Large capital
✅ Professional trader
✅ Specific strategies

Concentrated = Higher capital efficiency
```

## Tools for V2 LPs

### Analytics
```
- info.uniswap.org (official)
- APY.vision (track returns)
- Revert.finance (IL calculator)
- Zapper.fi (portfolio view)
- DeBank (cross-protocol)
```

### Calculators
```
IL Calculator:
- impermanentloss.com
- dailydefi.org/tools

APR Calculator:
- Based on fees/volume
- Consider IL impact
```

### Monitoring
```
Set alerts for:
- Large price movements
- Volume spikes
- TVL changes
- High gas periods
```

## Migration from V2 to V3

### Should You Migrate?
```
Consider if:
- Stable pair (less IL risk)
- Active management possible
- Want higher efficiency
- Gas costs acceptable

Stay V2 if:
- Passive approach
- Volatile pair
- Small position
- No time to manage
```

### Migration Process
```
1. Remove V2 liquidity
2. Receive tokens
3. Go to V3 interface
4. Add with concentration
5. Higher returns possible
6. More risk/complexity
```

## Emergency Procedures

### Stuck Transaction
```
Adding liquidity pending forever:
1. Speed up transaction
2. Cancel if needed
3. Check token approvals
4. Try again with higher gas
```

### Can't Remove Liquidity
```
Common causes:
- Insufficient gas
- Router contract issues
- Token paused

Solutions:
- Try during low gas
- Use different interface
- Direct contract interaction
```

### Massive IL Event
```
Token crashes 90%:
1. Don't panic
2. Assess recovery potential
3. Consider tax loss harvesting
4. Remove if truly dead
5. Learn from experience
```

## Best Practices Summary

### Before Providing
```
□ Research both tokens
□ Check pool history
□ Calculate potential IL
□ Verify contract addresses
□ Understand fee structure
□ Have exit strategy
```

### While Providing
```
□ Monitor daily
□ Track performance
□ Reinvest strategy
□ Rebalance if needed
□ Record for taxes
```

### Exit Strategy
```
□ Set profit targets
□ Define max IL tolerance
□ Plan tax optimization
□ Consider migration timing
□ Have next opportunity ready
```