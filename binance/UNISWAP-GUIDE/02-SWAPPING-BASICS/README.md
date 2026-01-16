# Swapping Complete Guide

## Getting Started

### Wallet Setup
```
Supported Wallets:
- MetaMask (most popular)
- WalletConnect
- Coinbase Wallet
- Rainbow
- Trust Wallet
- Hardware: Ledger, Trezor

Network Selection:
1. Ethereum Mainnet (highest liquidity)
2. Polygon (low fees)
3. Arbitrum (L2, medium fees)
4. Optimism (L2, growing)
5. Base (Coinbase L2)
```

### First Time Setup
```
1. Install MetaMask
2. Create/Import wallet
3. Add network (if L2)
4. Get gas tokens (ETH for mainnet)
5. Visit app.uniswap.org
6. Connect wallet
7. Switch to correct network
```

## The Swap Interface

### Main Components
```
[From Token ▼] [Amount: 1.0        ]
        ↓ (flip button)
[To Token ▼  ] [Amount: 3,995.25   ]

[Slippage: Auto ⚙️] [Deadline: 30min]

[Connect Wallet / Swap Button      ]
```

### Token Selection
```
Search by:
- Name: "Ethereum"
- Symbol: "ETH"
- Contract: 0x...

Token Lists:
- Default (Uniswap vetted)
- CoinGecko
- Kleros
- Custom imports

⚠️ Warning: Fake tokens exist!
Always verify contract address
```

### Input Methods
```
1. Type amount in "From"
   → Auto-calculates "To"

2. Type amount in "To"
   → Auto-calculates "From"

3. Max button
   → Uses full balance minus gas

4. USD value input
   → Converts to token amount
```

## Settings Deep Dive

### Slippage Tolerance
```
What it means:
Maximum price change you accept

Auto Mode:
- 0.5% for stable pairs
- 1% for normal pairs
- 2-5% for volatile pairs

Custom Settings:
Low liquidity: 5-10%
New tokens: 10-20%
Stable pairs: 0.1%

Warning signs:
🔴 >5%: "High slippage"
🔴 <0.1%: "Transaction may fail"
```

### Transaction Deadline
```
Default: 30 minutes
Meaning: Transaction expires after X minutes

When to adjust:
- Network congestion: Increase to 60min
- Volatile market: Decrease to 5min
- Normal: Keep 30min
```

### Expert Mode
```
Enables:
- High slippage without warnings
- Skip transaction preview
- Direct routing control

⚠️ Dangerous for beginners!
```

### MEV Protection (Auto)
```
Sends transaction privately
Prevents sandwich attacks
Slightly slower execution
Recommended for trades >$1,000
```

## Price Impact & Calculations

### Price Impact Levels
```
🟢 <0.1%: Negligible
🟢 0.1-0.5%: Low
🟡 0.5-2%: Medium
🔴 2-5%: High
⚫ >5%: Severe

Formula:
Impact = |Execution Price - Market Price| / Market Price
```

### Real Examples
```
Swap 0.1 ETH → USDC:
Pool: 1000 ETH / 4M USDC
Output: ~399.5 USDC
Impact: 0.01%

Swap 10 ETH → USDC:
Same pool
Output: ~39,200 USDC
Impact: 2%
Average price: $3,920 vs $4,000 market
```

### Minimum Received
```
Calculation:
Expected Output × (1 - Slippage)

Example:
Expected: 1000 USDC
Slippage: 1%
Minimum: 990 USDC

If price moves beyond this, transaction reverts
```

## Routing & Path Finding

### Direct Pairs
```
ETH → USDC (direct pool exists)
Single hop, lowest gas
0.3% fee

Gas: ~120,000
Cost: $20-50 on mainnet
```

### Multi-hop Routes
```
ETH → RARE_TOKEN
No direct pool
Route: ETH → USDC → RARE_TOKEN

Two swaps, double fees
Gas: ~180,000
But might have better price
```

### Split Routes (V3)
```
Large trade splits across:
- V3 0.05% pool (50%)
- V3 0.3% pool (30%)
- V2 pool (20%)

Optimizes for best execution
Higher gas but better price
```

### Auto Router Logic
```
Considers:
1. Pool liquidity
2. Price impact
3. Gas costs
4. Fee tiers

Chooses optimal path
Updates every block
```

## Fee Structure

### V2 Fees
```
Fixed: 0.3% on all swaps
Goes to: Liquidity providers

Example:
Swap 1 ETH
Fee: 0.003 ETH
You get: 0.997 ETH worth
```

### V3 Fee Tiers
```
0.01%: Stable pairs (USDC/DAI)
0.05%: Major pairs (ETH/USDC)
0.30%: Standard pairs
1.00%: Exotic pairs

Lower fee = Tighter spreads
Higher fee = Better for LPs
```

### Real Cost Calculation
```
Total Cost = Gas Fee + Swap Fee + Price Impact

Example ($1000 swap):
Gas: $30
Swap fee: $3 (0.3%)
Price impact: $5 (0.5%)
Total: $38 (3.8%)
```

## Token Approvals

### What Are Approvals?
```
Permission for contract to spend tokens
Required for ERC-20 tokens
Not needed for ETH

Process:
1. Approve token (one-time)
2. Swap token (each time)
```

### Approval Types
```
Exact Amount:
- Approve only what you swap
- Safer but more gas
- Need new approval each time

Infinite Approval:
- Approve max amount
- One-time gas cost
- Security risk if contract hacked
```

### Revoke Approvals
```
Use: revoke.cash
Check all approvals
Revoke unused ones
Costs gas but increases security
```

## Transaction Process

### Step-by-Step Flow
```
1. Enter swap details
2. Click "Swap"
3. Review transaction preview
4. Confirm in wallet
5. Wait for confirmation
6. Transaction complete
```

### Transaction Preview
```
Shows:
- Rate: 1 ETH = 3,995 USDC
- Price impact: 0.12%
- Minimum received: 3,955 USDC
- Network fee: $25
- Route: ETH → USDC (direct)
```

### Wallet Confirmation
```
MetaMask shows:
- Contract interaction
- Estimated gas fee
- Max fee
- Total amount

Can edit:
- Gas price (slow/normal/fast)
- Gas limit (don't lower)
- Priority fee (for miners)
```

### Transaction States
```
Pending: Waiting for miners
Confirmed: In block
Success: Swap complete
Failed: Reverted (keep gas fee)
```

## Common Issues & Solutions

### Transaction Failures

#### "Insufficient Liquidity"
```
Cause: Not enough tokens in pool
Solutions:
- Reduce swap amount
- Increase slippage
- Try different route
- Wait for more liquidity
```

#### "Price Impact Too High"
```
Cause: Large swap, small pool
Solutions:
- Split into smaller swaps
- Use limit orders
- Try different pairs
- Use aggregator
```

#### "Transaction Expired"
```
Cause: Deadline passed
Solutions:
- Increase deadline
- Use higher gas
- Try again immediately
```

#### "Cannot Estimate Gas"
```
Causes:
- Insufficient balance
- Token not approved
- Slippage too low
- Contract paused

Debug:
- Check token balance
- Check gas token balance
- Increase slippage
- Try smaller amount
```

### Stuck Transactions
```
Problem: Transaction pending forever

Solutions:
1. Speed up (increase gas)
2. Cancel (same nonce, 0 value)
3. Wait (might clear eventually)

Prevention:
- Use appropriate gas
- Check network congestion
- Don't spam transactions
```

## Gas Optimization

### Best Times to Trade
```
Low congestion (UTC):
- Weekends
- 2 AM - 6 AM
- Holidays

Gas typically:
Weekend: 20-30 Gwei
Weekday: 30-50 Gwei
Peak: 100+ Gwei
```

### Gas Saving Tips
```
1. Use L2s when possible
2. Combine approvals
3. Avoid multi-hop if small trade
4. Wait for low gas
5. Use limit orders for large trades
```

### Layer 2 Comparison
```
Network     | Gas Cost | Speed  | Liquidity
------------|----------|--------|----------
Ethereum    | $20-100  | 12 sec | Highest
Arbitrum    | $1-5     | 2 sec  | High
Optimism    | $1-5     | 2 sec  | Medium
Polygon     | $0.01-1  | 2 sec  | Medium
Base        | $0.1-2   | 2 sec  | Growing
```

## Advanced Features

### Limit Orders (V3)
```
Set specific price to execute
No gas until filled
Good for:
- Large trades
- Buying dips
- Taking profits

Example:
Current ETH: $2,000
Limit buy at: $1,900
Order fills if price drops
```

### TWAP Orders
```
Time-Weighted Average Price
Split large order over time
Reduces price impact

Example:
Buy 100 ETH over 1 hour
Executes as 60 small orders
Average price, less impact
```

### Permit2
```
New approval system
One signature for all tokens
Better UX, same security
Reduces transactions
```

## Price Alerts

### Setting Alerts
```
Tools:
- Uniswap mobile app
- DeBank
- Zapper
- CoinGecko

Alert types:
- Price targets
- Liquidity changes
- Large swaps
- Pool creation
```

## Mobile vs Desktop

### Mobile App Features
```
✅ Basic swaps
✅ Wallet connect
✅ Price charts
✅ Notifications
❌ Advanced routing
❌ Detailed analytics
❌ Limit orders
```

### When to Use Each
```
Mobile:
- Quick swaps
- Price checking
- On-the-go trading

Desktop:
- Large trades
- Complex routes
- Research
- LP management
```

## Integration with Other Protocols

### 1inch Aggregator
```
Compares all DEXs
Finds best price
Splits across venues
Higher gas, better price
```

### Matcha
```
0x protocol
Gasless quotes
Professional routing
RFQ system
```

### CoWSwap
```
Batch auctions
MEV protection
Better prices
Slower execution
```

## Best Practices

### Before Swapping
```
1. Verify token contract
2. Check liquidity depth
3. Compare prices (aggregators)
4. Set appropriate slippage
5. Have extra ETH for gas
```

### During Swap
```
1. Start with small test
2. Don't rush
3. Double-check amounts
4. Review gas fees
5. Confirm route
```

### After Swap
```
1. Verify receipt
2. Check balance
3. Save transaction hash
4. Record for taxes
5. Revoke approvals if done
```

## Tax Implications

### Every Swap Is Taxable
```
ETH → USDC = Selling ETH
USDC → ETH = Buying ETH
Both create tax events

Track:
- Date/time
- From token/amount
- To token/amount
- USD values
- Gas fees
```

### Tools for Tracking
```
- Koinly
- TokenTax
- CoinTracker
- Etherscan export
- Custom spreadsheet
```

## Security Checklist

```
□ Official URL (app.uniswap.org)
□ Verify token contracts
□ Check approval amounts
□ Review transaction details
□ Appropriate slippage
□ Sufficient gas
□ No suspicious activity
□ Hardware wallet for large amounts
□ Test with small amount first
□ Record transaction details
```