# Uniswap V2 Periphery Contracts Guide

This folder contains the production routers, migration helper, shared libraries, interface surface, and example contracts that demonstrate how to integrate Uniswap V2 from Solidity.

## File Map and Responsibilities
- `UniswapV2Router01.sol`: Core add/remove liquidity and swap entrypoints (tokens ↔ tokens, ETH wrapping via WETH). Implements slippage protection with `deadline` and min/max bounds, and exposes price helpers via `UniswapV2Library`.
- `UniswapV2Router02.sol`: Extends Router01 with fee-on-transfer token support and additional swap/remove helpers while keeping the same factory/WETH wiring. Use this router for most modern deployments.
- `UniswapV2Migrator.sol`: Bridges Uniswap V1 LP positions to V2 by burning V1 liquidity, then adding proportional V2 liquidity through Router01. Returns any unused token/ETH dust.
- `libraries/UniswapV2Library.sol`: Pure/view helpers for pair address derivation, reserve fetching, and constant-product math (`quote`, `getAmountOut/In`, path-wide `getAmountsOut/In`).
- `libraries/UniswapV2LiquidityMathLibrary.sol`: Calculates token amounts and liquidity deltas given reserves/fees (useful for frontends or analytics).
- `libraries/UniswapV2OracleLibrary.sol`: Time-weighted price helper (cumulative price observation handling).
- `libraries/SafeMath.sol`: Solidity 0.6 overflow-safe arithmetic.
- `interfaces/`: ABI contracts for routers, migrator, ERC20, WETH, and V1 factory/exchange; reference them when interacting from other contracts.
- `examples/`: Ready-to-deploy patterns showing oracle construction, flash swaps, liquidity value calculation, and target-price swaps; each contract imports the real routers/libraries.
- `test/` (inside `contracts/`): Utility contracts (WETH9, ERC20 mocks, RouterEventEmitter, DeflatingERC20) used by the TS test suite.

## How the Pieces Connect
```mermaid
flowchart TB
  subgraph Routers
    R1[UniswapV2Router01]
    R2[UniswapV2Router02]
  end
  M[UniswapV2Migrator]
  L1[UniswapV2Library]
  L2[UniswapV2LiquidityMathLibrary]
  L3[UniswapV2OracleLibrary]
  F[Factory (core)]
  P[Pair (core)]
  W[WETH9]
  EX[Examples]
  V1[V1 Exchange]

  R1 -->|uses| L1
  R2 -->|uses| L1
  R1 -->|calls| F
  R2 -->|calls| F
  F -->|creates| P
  R1 -->|mints/burns| P
  R2 -->|mints/burns| P
  R1 -->|wraps| W
  R2 -->|wraps| W
  M -->|burns LP in| V1
  M -->|adds via| R1
  EX -->|imports| R2
  EX -->|imports| L1
  EX -->|imports| L3
  L2 -->|math for| EX
```

## Usage Patterns
- **Add liquidity (Router02)**: Approve tokenA/tokenB to router, then call `addLiquidity(tokenA, tokenB, amtADesired, amtBDesired, amtAMin, amtBMin, to, deadline)`. Router computes optimal ratio against reserves and mints LP tokens to `to`.
- **Add liquidity with ETH**: Send ETH value and call `addLiquidityETH(token, amtTokenDesired, amtTokenMin, amtETHMin, to, deadline)`. Router wraps ETH into WETH, pairs it, mints LP, and refunds extra ETH.
- **Remove liquidity**: Call `removeLiquidity(tokenA, tokenB, liquidity, minA, minB, to, deadline)`; router burns LP at the pair, checks slippage, and transfers tokens to `to`. Use `removeLiquidityETH` to unwrap into native ETH. Permit variants skip on-chain approvals by supplying EIP-2612 signatures.
- **Swap exact input**: `swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline)` transfers `amountIn` to the first pair, hops along `path`, and ensures the final output meets `amountOutMin`. ETH entry/exit helpers wrap/unwrap WETH automatically.
- **Swap for exact output**: `swapTokensForExactTokens(amountOut, amountInMax, path, to, deadline)` pulls up to `amountInMax` and reverts if more is needed. ETH combinations exist for all permutations.
- **Fee-on-transfer tokens**: Use `swapExactTokensForTokensSupportingFeeOnTransferTokens` or its ETH variants; these measure pool deltas at each hop instead of relying on precomputed amounts.
- **Migrate from V1**: Call `migrate(token, amountTokenMin, amountETHMin, to, deadline)` on `UniswapV2Migrator` while holding V1 LP tokens. The migrator burns V1 liquidity, routes assets into `addLiquidityETH`, and forwards any leftovers.
- **Oracle examples**: `examples/ExampleOracleSimple.sol` and `ExampleSlidingWindowOracle.sol` show how to read cumulative prices from V2 pairs using `UniswapV2OracleLibrary`.
- **Flash swaps**: `ExampleFlashSwap.sol` demonstrates borrowing tokens with zero upfront cost by implementing the pair callback and repaying with fee inside the transaction.
- **Swap-to-price**: `ExampleSwapToPrice.sol` illustrates iterative swaps to target a specific output price using library math and router swaps.
- **Liquidity value**: `ExampleComputeLiquidityValue.sol` uses `UniswapV2LiquidityMathLibrary` to compute post-fee, post-arbitrage liquidity share values.

## Interactions and Best Practices
- Routers depend on the canonical factory/pair contracts from Uniswap V2 core; pass the deployed factory and WETH addresses into the constructor.
- Deadline checks (`ensure`) protect users from stuck transactions; always set near-term timestamps.
- Slippage safety: all add/remove/swap functions enforce caller-provided min/max bounds; compute these off-chain with `getAmountsOut`/`getAmountsIn`.
- ETH handling: routers never accept arbitrary ETH—only WETH unwraps/receives and swap entrypoints marked `payable` will handle value; excess ETH is refunded.
- Approvals: ERC20 interactions go through `TransferHelper` to provide consistent reverts; permit-enabled removes reduce allowance setup transactions.
- Library reuse: call the public `quote/getAmountOut/getAmountIn/getAmountsOut/getAmountsIn` view functions on Router02 for deterministic math identical to on-chain execution.

## Quick Reference Examples (Solidity snippets)
```solidity
// 1) Swap exact 100 DAI to USDC via WETH path
address[] memory path = new address[](3);
path[0] = DAI; path[1] = WETH; path[2] = USDC;
IERC20(DAI).approve(router, 100e18);
IUniswapV2Router02(router).swapExactTokensForTokens(
    100e18, 99e6, path, msg.sender, block.timestamp + 300
);

// 2) Remove liquidity for token + ETH with permit
IUniswapV2Router02(router).removeLiquidityETHWithPermit(
    TOKEN, lpAmount, minToken, minETH, msg.sender, block.timestamp + 300,
    true, v, r, s
);

// 3) Flash swap example callback skeleton
function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {
    // Use borrowed tokens, then repay amount + fee to the pair before returning
    uint fee = ((amount0 > 0 ? amount0 : amount1) * 3) / 997 + 1;
    IERC20(borrowedToken).transfer(msg.sender, borrowedAmount + fee);
}
```

## Additional Worked Examples
```solidity
// 4) Migrate V1 LP to V2 (burn V1 liquidity, add V2, refund dust)
IUniswapV2Migrator(migrator).migrate(
    TOKEN, amountTokenMin, amountETHMin, msg.sender, block.timestamp + 300
);

// 5) Swap taxed tokens with output check based on actual received amounts
address[] memory path = new address[](2);
path[0] = FEE_TOKEN; path[1] = WETH;
IERC20(FEE_TOKEN).approve(router, amountIn);
IUniswapV2Router02(router).swapExactTokensForTokensSupportingFeeOnTransferTokens(
    amountIn, minWethOut, path, msg.sender, block.timestamp + 300
);

// 6) Sliding window TWAP: update bucket, then consult price
ExampleSlidingWindowOracle oracle = ExampleSlidingWindowOracle(oracleAddr);
oracle.update(tokenA, tokenB); // write cumulative price for current epoch
uint twapOut = oracle.consult(tokenA, 1e18, tokenB); // average amount of tokenB per 1 tokenA

// 7) Compute liquidity value (post-fee) for an LP position
(uint tokenAValue, uint tokenBValue) = UniswapV2LiquidityMathLibrary.getLiquidityValue(
    factory, tokenA, tokenB, liquidityAmount
);
```
