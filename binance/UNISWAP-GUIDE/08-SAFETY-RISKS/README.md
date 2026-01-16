# Safety & Risks Complete Guide

## Smart Contract Risks

### Uniswap Contract Security
```
V2 Status:
- Live since 2020
- $10B+ processed
- Multiple audits
- Battle-tested
- Risk: Very Low

V3 Status:
- Live since 2021
- Complex code
- Audited extensively
- Some edge cases
- Risk: Low

V4 Status:
- In development
- New architecture
- Hooks = new risks
- Risk: Unknown
```

### Historical Incidents
```
Major bugs: None in core contracts
Minor issues:
- Router vulnerabilities (patched)
- Periphery contract bugs
- No user funds lost directly

Comparison:
Other protocols hacked: $3B+ total
Uniswap direct hacks: $0
```

### Code Audit Results
```
Auditors:
- Trail of Bits
- ABDK
- Samczsun
- OpenZeppelin

Findings:
- Mostly low/medium severity
- All critical fixed before launch
- Ongoing bug bounty program
```

## Common Scams & How to Avoid

### Fake Tokens
```
The Problem:
Anyone can create "ETH" token
Scammers create lookalikes
You swap real tokens for fake

Protection:
✅ Verify contract address
✅ Check official sources
✅ Look for liquidity depth
✅ See holder count
✅ Check social channels
```

### Honeypot Tokens
```
How they work:
- Can buy but can't sell
- Hidden transfer restrictions
- Blacklist functions
- High sell tax (99%)

Red flags:
- Only green candles
- No sells in history
- Locked liquidity claims
- Too good to be true APR
```

### Fake Uniswap Sites
```
Common URLs:
- unifswap.org (fake)
- uniswop.org (fake)
- app-uniswap.com (fake)

Real URL only:
app.uniswap.org

Protection:
- Bookmark real site
- Check SSL certificate
- Never Google search
- Use official links
```

### Approval Scams
```
Malicious contracts request:
- Infinite approval
- Transfer permissions
- Hidden functions

Once approved, drain wallet

Protection:
- Read transactions carefully
- Limit approvals
- Revoke unused
- Use hardware wallet
```

## MEV Attack Vectors

### Sandwich Attacks
```
Your risk:
- Large trades
- High slippage
- Public mempool

Protection:
1. Use Flashbots Protect RPC
2. Set slippage to 0.5% max
3. Split large trades
4. Use limit orders
```

### Front-running
```
Bot sees your transaction
Executes same trade first
You get worse price

Mitigation:
- Private mempools
- Commit-reveal schemes
- MEV protection services
```

### JIT Liquidity Attacks
```
Attacker adds liquidity
Just before your trade
Takes most fees
Removes after

Impact: Less fees for regular LPs
Protection: Hard to prevent
```

## Wallet Security

### Hot Wallet Risks
```
MetaMask/Browser wallets:
- Malware vulnerable
- Phishing attacks
- Browser exploits
- Clipboard hijacking

Best practices:
- Separate trading wallet
- Limited funds only
- Regular transfers out
- Different computer
```

### Hardware Wallet Setup
```
Recommended:
- Ledger Nano X
- Trezor Model T
- GridPlus Lattice1

Setup:
1. Buy direct from manufacturer
2. Generate seed offline
3. Write seed on paper/metal
4. Never digitize seed
5. Test recovery process
```

### Multi-Sig Solutions
```
Gnosis Safe:
- Multiple signers required
- Time delays possible
- Perfect for LP positions
- Higher gas costs

Example:
2-of-3 multisig
Need 2 approvals to trade
One key compromised = safe
```

## Phishing Prevention

### Email Phishing
```
Red flags:
- Urgency ("Act now!")
- Bad grammar
- Generic greeting
- Suspicious sender
- Hover links (wrong URL)

Uniswap NEVER:
- Emails you first
- Asks for seed phrase
- Requires "verification"
```

### Discord/Telegram Scams
```
Common attacks:
- Fake admin DMs
- "Support" messages
- Airdrop claims
- Wallet validators

Rules:
- Admins never DM first
- No legitimate "validators"
- Ignore all DMs
- Only trust official channels
```

### Google Ads Attacks
```
Scammers buy ads for:
"Uniswap" searches
Top result = Fake site

Protection:
- Never use search
- Direct URL only
- Ad blockers help
- Bookmark real site
```

## Transaction Safety

### Reading Transactions
```
Before signing, check:
1. Contract address (correct?)
2. Function called (expected?)
3. Token amounts (right?)
4. Approval amounts (limited?)
5. Gas fee (reasonable?)

Red flags:
- Unknown contract
- Infinite approvals
- Hidden data
- Unusual gas
```

### Simulation Tools
```
Tenderly Fork:
- Test transaction first
- See exact outcome
- No real funds

Pocket Universe:
- Browser extension
- Pre-sign warnings
- Risk detection
```

### Transaction Monitoring
```
After signing:
- Watch on Etherscan
- Verify execution
- Check balances
- Note irregularities

If suspicious:
- Revoke approvals immediately
- Move funds
- Report incident
```

## Protocol-Specific Risks

### Liquidity Risks
```
Rug pulls:
- Dev removes liquidity
- Token becomes worthless
- Your LP position = $0

Protection:
- Check liquidity locks
- Verify team
- Start small
- Avoid new pairs
```

### Oracle Manipulation
```
Flash loan attacks:
- Manipulate pool price
- Liquidate positions
- Steal funds

Uniswap defense:
- TWAP oracles
- Multi-block prices
- Still some risk
```

### Governance Attacks
```
Risk: Malicious proposals
51% attack possibility
Treasury drainage

Protection:
- Monitor proposals
- Delegate wisely
- Participate in votes
```

## Network & Technical Risks

### Network Congestion
```
High gas periods:
- NFT mints
- Popular launches
- Market volatility

Risks:
- Stuck transactions
- Failed swaps
- Can't exit positions

Mitigation:
- Gas alerts
- Multiple RPCs
- Layer 2 backup
```

### Chain Reorganization
```
Blocks can be replaced
Transactions reversed
Rare but possible

Protection:
- Wait confirmations
- Large trades: 12+ blocks
- Monitor reorgs
```

### Bridge Risks
```
Cross-chain bridges:
- Highest risk in DeFi
- $2B+ hacked historically
- Complex systems

If using bridges:
- Minimum amounts
- Official bridges only
- Quick movements
- Don't store in bridge
```

## Economic Risks

### Impermanent Loss
```
Risk levels:
Stable pairs: 0-1%
Correlated: 1-10%
Volatile: 10-50%
Exotic: 50-100%

Management:
- Calculate beforehand
- Set loss limits
- Monitor daily
- Exit if exceeds
```

### Regulatory Risk
```
Potential issues:
- DEX bans
- Token delistings
- Tax changes
- KYC requirements

Preparation:
- Multiple protocols
- Geographic diversification
- Compliance ready
- Document everything
```

### Systemic Risks
```
Black swan events:
- Stablecoin depeg
- Major hack
- Regulatory shutdown
- Economic crisis

Protection:
- Diversification
- Stop losses
- Regular withdrawals
- Don't overleverage
```

## Emergency Procedures

### Compromised Wallet
```
Immediate actions:
1. Transfer all assets out
2. Use different wallet
3. Revoke all approvals
4. Check connected sites
5. Never use again

Recovery:
- Create new wallet
- Update all services
- Learn from incident
```

### Stuck Transaction
```
Options:
1. Speed up (increase gas)
2. Cancel (same nonce, 0 ETH)
3. Wait (might clear)

Prevention:
- Appropriate gas
- Check network status
- Don't spam transactions
```

### Lost Position
```
Can't see LP position?

Check:
1. Correct network
2. Correct wallet
3. Old Uniswap versions
4. Etherscan history
5. The Graph queries
```

### Protocol Hack
```
If Uniswap hacked:
1. Remove liquidity ASAP
2. Revoke approvals
3. Monitor announcements
4. Document losses
5. Join recovery efforts
```

## Best Practices Checklist

### Daily Security
```
□ Check address before sending
□ Verify token contracts
□ Review transaction details
□ Monitor gas prices
□ Check position health
□ Read protocol news
```

### Weekly Tasks
```
□ Review approvals
□ Check wallet security
□ Update software
□ Backup important data
□ Review positions
□ Calculate P&L
```

### Monthly Review
```
□ Audit all positions
□ Revoke unused approvals
□ Update security setup
□ Tax documentation
□ Strategy adjustment
□ Emergency plan update
```

## Risk Scoring Framework

### Position Risk Score
```
Calculate your risk:

Token Quality (0-3):
□ Blue chip (0)
□ Established (1)
□ New/small (2)
□ Meme/unknown (3)

Position Size (0-3):
□ <5% portfolio (0)
□ 5-20% (1)
□ 20-50% (2)
□ >50% (3)

Strategy Complexity (0-3):
□ Simple swap (0)
□ Basic LP (1)
□ Concentrated V3 (2)
□ Leveraged/complex (3)

Total Score:
0-3: Low risk
4-6: Medium risk
7-9: High risk
```

## Security Tools

### Essential Tools
```
1. Revoke.cash - Approval management
2. Etherscan - Transaction verification
3. DeFi Safety - Protocol ratings
4. CertiK - Audit database
5. Immunefi - Bug bounties
```

### Monitoring Services
```
- Forta Network: Threat detection
- Chainalysis: Address screening
- TRM Labs: Risk scoring
- Elliptic: Compliance tools
```

## Insurance Options

### Protocol Insurance
```
Nexus Mutual:
- Smart contract coverage
- Protocol specific
- 2-10% annual premium

InsurAce:
- Multiple protocols
- Bundled coverage
- Claim process exists
```

### Self-Insurance
```
Set aside 10-20% of profits
Emergency fund for:
- IL coverage
- Gas spikes
- Lost opportunities
- Hack recovery
```

## Learning from Incidents

### Major DeFi Hacks
```
Study these for lessons:
- Poly Network ($600M)
- Wormhole ($320M)
- Ronin ($620M)
- FTX collapse

Common factors:
- Bridge vulnerabilities
- Private key compromise
- Governance attacks
- Economic exploits
```

### Personal Stories
```
Common mistakes:
- Infinite approvals
- Fake token swaps
- Phishing sites
- Lost seeds
- Tax ignorance

Learn from others' losses
```

## Regulatory Compliance

### KYC Considerations
```
DEX = No KYC currently
Future may require:
- Identity verification
- Transaction monitoring
- Reporting requirements

Prepare:
- Clean transaction history
- Documented sources
- Tax compliance
```

### Sanctions Compliance
```
Tornado Cash precedent:
- Smart contracts sanctioned
- Users prosecuted
- Broad implications

Stay safe:
- Check OFAC lists
- Avoid suspicious addresses
- Document legitimate use
```

## Final Safety Rules

### The 10 Commandments
```
1. Never share seed phrases
2. Verify everything twice
3. Start small, scale slowly
4. Revoke unused approvals
5. Use hardware wallets for large amounts
6. Keep records for taxes
7. Diversify across protocols
8. Monitor daily
9. Have exit strategies
10. If unsure, don't do it
```

### Risk/Reward Balance
```
Higher returns = Higher risk
No free lunch in DeFi

Sustainable approach:
- 60% safe strategies
- 30% medium risk
- 10% experiments

Never risk what you can't afford to lose
```