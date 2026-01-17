# Getting Started Complete Guide

## Prerequisites

### What You Need
```
1. MetaMask or compatible wallet
2. USDC on Arbitrum (for bridging)
3. Small ETH on Arbitrum (for gas)
4. Basic understanding of perpetuals
5. Risk management plan
```

### Wallet Setup

#### MetaMask Configuration
```
1. Install MetaMask extension
2. Create/import wallet
3. Add Arbitrum Network:
   - Network Name: Arbitrum One
   - RPC URL: https://arb1.arbitrum.io/rpc
   - Chain ID: 42161
   - Symbol: ETH
   - Explorer: https://arbiscan.io

4. Add Hyperliquid Network:
   - Network Name: Hyperliquid
   - RPC URL: Coming soon
   - Chain ID: [TBD]
```

#### Security Best Practices
```
✅ Use hardware wallet for large amounts
✅ Separate trading wallet
✅ Never share seed phrase
✅ Bookmark official sites
✅ Enable 2FA where possible
```

## Getting Funds to Hyperliquid

### Step 1: Acquire USDC

#### Option A: Buy on CEX
```
1. Buy USDC on Binance/Coinbase
2. Withdraw to Arbitrum network
3. Select Arbitrum One (not Nova)
4. Pay withdrawal fee (~$5)
5. Wait 10-30 minutes
```

#### Option B: Buy on DEX
```
1. Have ETH on Arbitrum
2. Go to Uniswap (Arbitrum)
3. Swap ETH for USDC
4. Keep some ETH for gas
```

#### Option C: Bridge from Ethereum
```
1. Use official Arbitrum bridge
2. Bridge USDC from Ethereum
3. Wait 10-15 minutes
4. Pay L1+L2 gas (~$20-50)
```

### Step 2: Bridge to Hyperliquid

#### Using Official Bridge
```
1. Go to app.hyperliquid.xyz
2. Click "Bridge"
3. Connect wallet
4. Select amount of USDC
5. Approve USDC (one-time)
6. Confirm bridge transaction
7. Wait 10-30 minutes
```

#### Bridge Fees
```
Deposit:
- Arbitrum gas: $1-5
- No Hyperliquid fee
- Total: $1-5

Withdrawal:
- Hyperliquid fee: 0
- Arbitrum gas: $1-5
- Total: $1-5
```

#### Bridge Limits
```
Minimum: $10 USDC
Maximum: No limit (large amounts may take longer)
Daily limit: None currently
```

### Step 3: Verify Arrival
```
1. Check balance on Hyperliquid
2. Should appear in 10-30 min
3. If delayed, check:
   - Transaction hash on Arbiscan
   - Bridge status page
   - Discord for issues
```

## Interface Overview

### Main Dashboard
```
[Trading View - Chart and positions]
[Order Book] [Trade Panel] [Positions]
[Account Info - Balance, Margin, P&L]
```

### Key Sections Explained

#### Account Balance
```
Wallet Balance: Total USDC
Margin Used: In positions
Free Margin: Available to trade
Unrealized P&L: Open positions
Realized P&L: Closed positions
```

#### Trading Panel
```
[Asset Selector: BTC-PERP ▼]
[Leverage Slider: 1x ----●---- 50x]
[Order Type: Market/Limit ▼]
[Size: Amount in USD]
[Reduce Only: □]
[Post Only: □]
```

#### Order Book Display
```
Price   | Size  | Total
50,105  | 12.5  | 12.5   } Asks
50,102  | 8.3   | 20.8   }
50,100  | 5.2   | 26.0   }
--------|-------|--------
50,098  | 4.1   | 4.1    }
50,095  | 10.2  | 14.3   } Bids
50,092  | 15.5  | 29.8   }
```

## First Trade Tutorial

### Setting Up
```
1. Select asset (start with BTC or ETH)
2. Set leverage (start with 2-5x)
3. Choose order type (limit recommended)
4. Enter size (start small, $100-500)
```

### Placing a Limit Order
```
Example Long Trade:
- Asset: BTC-PERP
- Current Price: $50,000
- Order Type: Limit
- Price: $49,950 (slightly below market)
- Size: $500
- Leverage: 5x
- Margin Required: $100

Click "Long" → Confirm → Order in book
```

### Market Order
```
Example:
- Asset: ETH-PERP
- Order Type: Market
- Size: $1,000
- Leverage: 10x
- Margin Required: $100
- Slippage: Check impact!

Click "Long/Short" → Instant execution
```

### After Execution
```
Check Position Tab:
- Entry price
- Current price
- Unrealized P&L
- Liquidation price
- Margin ratio
```

## Understanding the Numbers

### Margin Calculation
```
Required Margin = Position Size / Leverage

Example:
$10,000 position at 20x leverage
Margin needed: $10,000 / 20 = $500
```

### P&L Calculation
```
Long P&L = (Current - Entry) / Entry × Size
Short P&L = (Entry - Current) / Entry × Size

Example Long:
Entry: $50,000
Current: $51,000
Size: $10,000
P&L = (51,000 - 50,000) / 50,000 × 10,000 = $200
```

### Liquidation Price
```
Long: Liq = Entry × (1 - 1/Leverage + 0.005)
Short: Liq = Entry × (1 + 1/Leverage - 0.005)

Example (20x long at $50,000):
Liq = 50,000 × (1 - 0.05 + 0.005) = $47,750
```

## Funding Rates Explained

### What Are Funding Rates?
```
Hourly payments between longs and shorts
Positive rate: Longs pay shorts
Negative rate: Shorts pay longs
Keeps perp price near spot
```

### Funding Calculation
```
Funding Payment = Position Size × Funding Rate

Example:
Position: $10,000 long
Funding: 0.01% per hour
Payment: $10,000 × 0.0001 = $1/hour
Daily cost: $24
```

### Monitoring Funding
```
Check funding rates:
- Current rate (per hour)
- Historical average
- Payment countdown

High funding = Expensive to hold
Consider closing or switching sides
```

## Setting Risk Parameters

### Position Sizing
```
Never risk more than:
- 1-2% of account per trade
- 5% of account per day
- 10% of account total exposure

Example ($10,000 account):
- Max per trade: $200 risk
- Daily loss limit: $500
- Total exposure: $1,000 margin
```

### Stop Loss Setup
```
Always use stop losses!

Setting stops:
1. Click position
2. Set stop price
3. Choose stop type
4. Confirm

Recommended:
- 2-5% below entry for longs
- 2-5% above entry for shorts
```

### Take Profit Orders
```
Lock in gains:
1. Set TP at resistance/support
2. Partial TP (50% at first target)
3. Trail stop for remainder
```

## Common Beginner Mistakes

### Mistake 1: Over-leveraging
```
Problem: Using 50x on first trade
Result: Instant liquidation on 2% move
Solution: Start with 2-5x maximum
```

### Mistake 2: No Stop Loss
```
Problem: "It will come back"
Result: Full liquidation
Solution: Always set stops before entry
```

### Mistake 3: Ignoring Funding
```
Problem: High funding eats profits
Result: Profitable trade becomes loss
Solution: Monitor and factor into trades
```

### Mistake 4: Trading Illiquid Assets
```
Problem: Wide spreads on small caps
Result: Instant loss on entry
Solution: Stick to BTC/ETH initially
```

## Account Management

### Deposits & Withdrawals
```
Deposits:
- Click "Bridge"
- Follow steps
- 10-30 min wait

Withdrawals:
- Click "Withdraw"
- Enter amount
- Select network
- Confirm
- 10-60 min wait
```

### Viewing History
```
Trade History:
- All executed trades
- Entry/exit prices
- P&L per trade
- Fees paid

Export for taxes:
- CSV download available
- Include all trades
- Track funding payments
```

### Performance Tracking
```
Key Metrics:
- Total P&L
- Win rate
- Average win/loss
- Sharpe ratio
- Maximum drawdown

Review weekly to improve
```

## Mobile Trading

### Current Status
```
No official app yet
Mobile web works but limited
Desktop recommended for now
App in development
```

### Mobile Web Tips
```
If using mobile:
- Bookmark the site
- Use landscape mode
- Zoom for order book
- Simple trades only
- Check on desktop later
```

## Getting Help

### Official Resources
```
1. Discord (primary support)
2. Documentation
3. Twitter updates
4. Tutorial videos
```

### Community Resources
```
- Trading groups
- Strategy discussions
- Market analysis
- Risk management tips

Never trust:
- DMs with "support"
- Investment advice
- Guaranteed profits
- Wallet validators
```

## Practice Recommendations

### Week 1 Plan
```
Day 1-2: Interface familiarity
Day 3-4: Small trades (2x leverage)
Day 5-6: Different order types
Day 7: Review and analyze
```

### First Month Goals
```
- Consistent small profits
- No liquidations
- Understand funding impact
- Develop trading plan
- Track all trades
```

### Skill Progression
```
Beginner: Market orders, 2-5x
Intermediate: Limit orders, 5-15x
Advanced: Complex strategies, 15-30x
Expert: Market making, full range
```

## Troubleshooting

### Bridge Issues
```
Problem: Funds not arriving
Check:
- Transaction confirmed on Arbiscan
- Correct network selected
- Sufficient confirmations
- Bridge status page

Solution:
- Wait up to 1 hour
- Contact Discord support
- Provide transaction hash
```

### Trading Issues
```
Can't place order:
- Check free margin
- Verify price is valid
- Ensure not below minimum
- Check position limits

Order not filling:
- Price not reached
- Post-only rejected
- Insufficient liquidity
```

### Display Issues
```
If interface problems:
- Clear browser cache
- Try different browser
- Disable extensions
- Check internet connection
```

## Security Reminders

### Daily Habits
```
✅ Check positions before sleep
✅ Set stop losses always
✅ Monitor funding rates
✅ Review P&L
✅ Secure wallet
```

### Red Flags
```
🚨 Unexpected DMs
🚨 "Verify wallet" requests
🚨 Too-good-to-be-true offers
🚨 Pressure to trade
🚨 Unknown links
```

### Best Practices
```
- Use bookmark only
- Never share screens
- Separate trading funds
- Regular withdrawals
- Document trades
```

## Next Steps

### After Getting Started
```
1. Read Perpetual Trading guide
2. Learn order types
3. Understand liquidations
4. Study risk management
5. Consider HLP provision
```

### Continuous Learning
```
- Join Discord community
- Follow experienced traders
- Study market structure
- Practice consistently
- Track performance
```