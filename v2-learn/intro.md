# Uniswap v1 Intro for Beginners

## 1) Background and how to use it day-to-day (≈500-1000 words)
Uniswap v1 is one of the earliest automated market makers (AMMs) on Ethereum. Instead of an order book with bids and asks, each token gets its own exchange contract holding an ETH reserve and a token reserve. Price moves automatically through the constant-product rule (x * y = k). For a newcomer, the key idea is that you trade directly against a shared pool, and liquidity providers (LPs) earn a 0.3% fee on every trade. There is no central custodian, so you keep control of your wallet keys the whole time.

The story started because early decentralized exchanges were slow and illiquid. Uniswap v1 solved this by making every trade a predictable formula-driven swap. The pool does not care who you are: if you send ETH in, it sends tokens out using the curve. If you send tokens in, it sends ETH out. The more you push the price in one direction, the more the curve resists, which makes extreme price swings costly unless supported by liquidity. Arbitrage traders keep prices in line with the broader market by profiting from any gaps.

Using it feels like a small ritual. First, you pick a token, then your wallet talks to the token’s exchange contract. The contract checks how much you send, applies the 0.3% fee, computes output using the formula, and then ships tokens or ETH back. You confirm in your wallet, and Ethereum miners (or validators) include it in a block. LPs see their pool balances shift, and their fee cut is already in the reserves; no extra action is needed to receive it.

Here is the human view of the lifecycle:
```
[You] -> [Wallet] -> [Uniswap UI] -> [Exchange Contract] -> [Pool ETH/Token]
            ^               |                 |                  |
            |         shows quote        updates price       holds reserves
```

And the swap steps at a glance:
```
[Start] -> connect wallet -> choose pair -> enter amount
       -> set slippage -> sign tx -> wait block inclusion -> receive output
```

To get started as a user, you need a wallet (e.g., MetaMask), some ETH for gas, and the token you want to swap or pool. Visiting a front-end, you connect your wallet, select the token, and review the quote the contract will enforce. If you add liquidity, you deposit ETH and the matched amount of the token so that the pool keeps the same price ratio. In return, you receive LP tokens that track your share. Removing liquidity later gives you back ETH, tokens, and your slice of fees.

Mentally, think of Uniswap v1 as a vending machine with transparent math. The UI is just a helper; the real logic is in the exchange contract. Even if the UI disappears, you could still call the contract directly through a wallet or script. The simplicity is why v1 became a base layer for many later DeFi tools.

Key words to remember: “liquidity” is the combined pile of ETH and tokens, “slippage” is how much the price might move during your trade, and “gas” is the small ETH payment to the network for processing. Because v1 routes everything through ETH, every token swap is either ETH -> Token or Token -> ETH; two tokens trade by doing two hops through ETH. This design keeps contracts simple at the cost of extra gas when you bridge two tokens.

Using it safely means double-checking three things before you click confirm: the token address (avoid look-alikes), the minimum output (protects against price jumps), and the deadline (avoid stuck transactions if the mempool freezes). Unlike a centralized exchange, Uniswap never holds your keys; failures usually just mean a reverted transaction, not lost funds. When you are ready to try, start with tiny amounts to see how fees, gas, and slippage feel in practice. Once you are comfortable, scaling up is just a matter of sending larger inputs to the same predictable pool.

## 2) How each major feature works under the hood (≈500-1000 words)
**Swaps (ETH -> Token and Token -> ETH).** Every token has a dedicated exchange contract. When you swap ETH for a token, the contract takes your ETH, keeps 0.3% as a fee inside the pool, and uses the invariant x * y = k to decide how many tokens to send you. The output is `tokens_out = (token_reserve * eth_in * 997) / (eth_reserve * 1000 + eth_in * 997)`. The reverse direction mirrors the same rule. Price impact rises as your trade size becomes large relative to reserves.

**Adding liquidity.** LPs send ETH and the paired token in the exact ratio the pool already has so the price does not jump. The contract mints LP tokens proportional to the added liquidity compared with the pool total. Those LP tokens are receipts: hold them to own a slice of reserves and accumulated fees.

**Removing liquidity.** Burning LP tokens returns ETH and tokens based on the current pool balances. Because fees stayed in the pool, withdrawing later means you exit with slightly more than you put in (if volume happened), minus any price movement effects.

**Fees and incentives.** The flat 0.3% fee is added to reserves, making k grow. This growth is what rewards LPs. Arbitrageurs keep the pool aligned with external prices because any mispricing means they can profit until the curve returns to fair value. That self-correcting behavior keeps the pool useful.

**Factory and exchange discovery.** The Factory contract tracks which token has which exchange. When a new token exchange is created, Factory stores its address. Users or UIs call `getExchange(token)` to find where to send swaps.

Two quick visuals on the mechanics:
```
Swap flow (ETH -> Token):
[User] --ETH--> [Exchange] --tokens--> [User]
            fee stays inside pool
```

```
Liquidity lifecycle:
[LPs deposit] -> [LP tokens minted] -> [Trades pay fees into pool]
          -> [LPs burn LP tokens] -> [Get ETH + Token + fee share]
```

Key safeguards include slippage limits (you set a minimum output), deadline timestamps (avoid stuck tx), and approvals (for token -> ETH swaps you must approve the token allowance first). Because everything is on-chain, all steps are deterministic: quotes come from live reserves, and execution matches the math exactly unless someone else trades before your transaction confirms.

Two limits keep v1 predictable but also simple: it only knows about ETH pairs, and it does not have built-in price oracles beyond reading reserves. If you need a quote, the contract exposes `getEthToTokenInputPrice` and friends so you can simulate outputs before sending a real swap. The math uses integer arithmetic, so tiny rounding differences can occur, which is why a small slippage buffer is recommended. There is no native limit order; you build that behavior by combining slippage and deadlines or by running your own bot.

Liquidity providers face “impermanent loss,” which happens when the external market moves relative to the pool’s ratio. The pool automatically rebalances, so LPs end up holding more of the asset that fell in price and less of the one that rose. Fees can offset this, but it is important to know that providing liquidity is not a risk-free yield. Still, because v1 is formula-first and immutable, you always know how the pool will react: reserves adjust along the curve, fees stay in, and LP shares track proportional ownership at all times.

## 3) A concrete, lively example (≈500-1000 words)
Imagine an ETH/DAI pool that starts with 10 ETH and 20,000 DAI. That means the implied price is 1 ETH = 2,000 DAI. You arrive wanting to trade 1 ETH for DAI.

Step 1: You connect your wallet and see the quote. The contract will keep 0.003 ETH as fee (0.3%). It treats 0.997 ETH as the effective input. With reserves of 10 ETH and 20,000 DAI, the math outputs about `tokens_out = (20000 * 0.997) / (10 + 0.997) ≈ 1,815 DAI` (rounded). You accept and sign.

Step 2: The transaction lands. The pool now has 11 ETH (because you sent 1) and 18,185 DAI (because it sent out 1,815). The fee stayed inside, so k grew slightly. LPs just earned 0.003 ETH worth of value without doing anything.

Step 3: Later, another trader goes the other way, sending 2,000 DAI to get ETH. After fee, 1,994 DAI counts as input. The pool calculates ETH out and sends it. Prices move subtly toward the external market, and arbitrage keeps it honest.

Step 4: An LP decides to add liquidity. They must deposit ETH and DAI in the current ratio. With the updated reserves, suppose price is now 1 ETH = 1,950 DAI. To add 1 ETH worth, the LP contributes 1 ETH + 1,950 DAI. The contract mints LP tokens to represent their share.

Two pictures to cement the story:
```
Before your swap:
[Pool] 10 ETH | 20000 DAI
Price: 1 ETH = 2000 DAI
```

```
After 1 ETH -> DAI swap:
[Pool] 11 ETH | 18185 DAI
Fee: 0.003 ETH stays inside
Price moved slightly up (ETH cheaper in DAI terms)
```

Over time, fees accumulate, so LPs grow their claim. If the market price outside is 2,050 DAI per ETH, arbitrageurs will sell DAI into the pool until the internal price matches, and in doing so they pay more fees. The AMM does not chase prices; humans and bots do, and their actions keep liquidity usable. The example shows that even small trades adjust prices while respecting the curve, and that fees flow automatically to the liquidity side of the balance sheet.

To see removal in action, imagine months later you hold LP tokens that represent 10% of the pool. You call `removeLiquidity` and burn your LP tokens. If the pool now holds 30 ETH and 55,000 DAI thanks to growth and fees, you withdraw 3 ETH and 5,500 DAI. You did not need to calculate anything; the contract does it. Your result reflects both fee earnings and any price drift that happened while you were an LP.

Picture two friends to make it vivid: Alex trades often, paying the 0.3% fee each time, while Blair is an LP who never trades. Alex indirectly pays Blair because fees stay in the pool. If Alex trades during volatile times, Blair’s impermanent loss might grow, but active arbitrage keeps the price fair so Blair’s fee revenue has a chance to outweigh that loss. The pool sits like a public lake: anyone can scoop water (swap) or pour water in (provide liquidity), and the water level (price) moves smoothly according to the curve.

If you try to swap a huge amount, the curve shows its resistance. Suppose you attempt to swap 5 ETH in the same pool. The price impact will be noticeable because 5 ETH is half the reserve. The output will be far less than 5 * 2,000 DAI because each marginal unit you buy costs more. This illustrates why deep liquidity matters and why large trades may prefer split orders or waiting for more liquidity. Even so, the math stays transparent, and your minimum-output guardrail prevents surprises.

## 4) How clients call the interfaces (≈500-1000 words)
Clients talk to two contracts: Factory (to find the right exchange) and the Exchange itself (to swap or add/remove liquidity). Calls are simple, but each needs ETH for gas and, for token-to-ETH swaps, an ERC20 approval.

Basic client steps:
1) Connect a provider (e.g., MetaMask or an Infura endpoint).
2) Use the Factory address to call `getExchange(tokenAddress)`.
3) For ETH -> Token: send a transaction to `ethToTokenSwapInput(min_tokens, deadline)` with ETH attached.
4) For Token -> ETH: first `approve(exchange, token_amount)`, then call `tokenToEthSwapInput(token_amount, min_eth, deadline)`.
5) For adding liquidity: call `addLiquidity(min_liquidity, max_tokens, deadline)` while sending ETH; the contract pulls tokens using your approval.
6) For removing liquidity: call `removeLiquidity(amount, min_eth, min_tokens, deadline)` to burn LP tokens and receive reserves.

A call sequence diagram:
```
[Client] -> [Factory.getExchange(token)]
     -> receives exchange address
     -> calls Exchange.swap/add/remove with params
     -> waits for block inclusion
```

And the approval path for token sales:
```
[Client] --approve--> [Token Contract] --allowance set-->
[Client] --tokenToEthSwapInput--> [Exchange] --ETH back-->
```

Front-ends often wrap these calls in helper functions that set sensible deadlines and slippage values. Even so, you should check gas estimates and outputs. If the mempool moves the price before your transaction confirms, the slippage check cancels execution, keeping your funds safe. For scripts, libraries like ethers.js let you encode ABI calls directly; the ABI for v1 exchanges includes the swap and liquidity functions mentioned above. Remember that v1 only supports ETH pairs, so every trade routes through ETH.

A tiny ethers.js sketch shows the shape of a call:
```js
const exchange = new ethers.Contract(exchangeAddr, exchangeAbi, signer);
const deadline = Math.floor(Date.now() / 1000) + 600; // 10 minutes
const tx = await exchange.ethToTokenSwapInput(
  minTokensWanted,
  deadline,
  { value: ethers.utils.parseEther("0.1") } // sending 0.1 ETH
);
await tx.wait();
```

Parameter meaning: `min_tokens` (or `min_eth`) is your slippage guard, and `deadline` is a unix timestamp after which the call reverts if still pending. For token sales, the `approve` call sets an allowance; consider approving only the needed amount instead of unlimited. Gas cost depends on the branch: adding liquidity touches storage more than a simple swap, so estimates differ.

To listen for results, clients watch events like `TokenPurchase` or `AddLiquidity` emitted by the exchange. UIs use these to refresh balances without extra calls. Error cases are straightforward: insufficient output triggers a revert, missing allowance triggers a revert, and expired deadlines trigger a revert. Because failures revert state, funds stay safe aside from the gas you spent trying.

If you need price previews without trading, call the view helpers: `getEthToTokenInputPrice`, `getTokenToEthInputPrice`, and their “output” siblings for the reverse direction. These are read-only, so you can poll them often to render quotes. Remember that many swaps can happen between your preview and your transaction, so always set protective minimums.

Mobile wallets and hardware wallets follow the same flow: the UI prepares the call data, your signer device confirms, and the transaction goes to the network. For batch actions, you can chain approvals and swaps in scripts, but keeping them separate keeps failure modes clear. When testing, try a dry run on a forked chain to see exact gas use and outputs before paying mainnet fees.

## 5) How a user can deploy (≈500-1000 words)
Deploying Uniswap v1 involves three contracts: Factory, the Exchange template, and then individual Exchange instances per token. You can deploy on a testnet to practice without risk. Prerequisites: a wallet with test ETH, a Solidity toolchain (Hardhat or Truffle), and the v1 contract sources.

Deployment steps you can follow:
1) Deploy the Exchange contract bytecode (this acts as the template).
2) Deploy the Factory, passing the Exchange template address to its constructor so it knows what to clone.
3) For each ERC20 token you want to trade against ETH, call `factory.createExchange(tokenAddress)`. The factory returns the new exchange address and stores it for discovery.
4) Seed initial liquidity by sending ETH and tokens to `addLiquidity` on that exchange, matching a desired starting price.
5) Verify addresses and ABIs in your front-end so users can find the right pools.

A bird’s-eye view of deployment wiring:
```
[You deploy Exchange template]
        |
        v
[Factory knows template] --createExchange(token)--> [Token-specific Exchange]
```

And the first liquidity bootstrap:
```
[Deployer] --ETH + Tokens--> [New Exchange] --mints--> [LP tokens to deployer]
```

Best practices: start on a testnet, keep a small initial pool to limit risk, and publish the exchange address so others can verify it matches the expected token. Because v1 pairs only with ETH, every new token needs its own exchange contract; there is no direct token-token pool without routing through ETH. Once deployed, maintenance is minimal: the contracts are immutable, so upgrades mean deploying fresh contracts and migrating liquidity if desired. Keep backups of your deployment scripts and note the block numbers for transparency.

If you want a simple deploy script, a Hardhat task can do it in a few lines: load your signer, deploy the Exchange bytecode, deploy Factory with that address, then call `createExchange` for each token. Afterward, print the resulting addresses so your front-end can hardcode them. Seed liquidity right away; an empty pool cannot quote trades. When seeding, pick a starting price you are comfortable defending, because arbitrage will push it to the market rate quickly, and you want enough reserves so the first trades do not swing price wildly.

Operational tips: label your environment variables for private keys and RPC URLs, and avoid running deployment from a hot wallet. After deployment, verify the source on a block explorer so others can audit the bytecode. On the UI side, store the Factory and exchange addresses in a config file and give users a clear token list so they do not paste wrong addresses. For governance or upgrades, remember v1 contracts are immutable; changes mean redeploying, so communicate any migrations early and provide a script to move LPs.

Before inviting others, run a quick swap and a full add/remove liquidity cycle yourself to confirm everything works. Watch the emitted events and final balances to make sure fee accounting lines up with expectations. A small README with the deployed addresses and basic function calls will save your users time and reduce mistakes.

With these steps, even a beginner can stand up a v1-style pool, understand how swaps move prices, and see how fees accumulate for LPs. The process is mostly about wiring the right addresses and keeping approvals and deadlines safe. Once live, the pool behaves predictably according to the invariant that made Uniswap famous.
