pragma solidity =0.6.6;

// Uniswap V2 Migrator
// This helper pulls Uniswap V1 LP tokens from a user, withdraws the underlying
// token/ETH from the V1 exchange, and immediately adds equivalent liquidity to
// Uniswap V2 via Router01. Any leftover token or ETH (dust) is refunded.

import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

import './interfaces/IUniswapV2Migrator.sol';
import './interfaces/V1/IUniswapV1Factory.sol';
import './interfaces/V1/IUniswapV1Exchange.sol';
import './interfaces/IUniswapV2Router01.sol';
import './interfaces/IERC20.sol';

contract UniswapV2Migrator is IUniswapV2Migrator {
    // Immutable pointer to the V1 factory; used to locate the V1 exchange for a token.
    IUniswapV1Factory immutable factoryV1;
    // Immutable reference to the V2 router used to add liquidity with recovered assets.
    IUniswapV2Router01 immutable router;

    constructor(address _factoryV1, address _router) public {
        // Cache constructor params so subsequent calls do not re-read from storage.
        factoryV1 = IUniswapV1Factory(_factoryV1);
        router = IUniswapV2Router01(_router);
    }

    // needs to accept ETH from any v1 exchange and the router. ideally this could be enforced, as in the router,
    // but it's not possible because it requires a call to the v1 factory, which takes too much gas
    receive() external payable {}

    /**
     * Example (story-style): Alice holds 10 V1 LP tokens for TOKEN/ETH and wants V2 LP instead.
     * - When to call: after you’ve approved this migrator to spend your V1 LP tokens.
     * - Who calls: an end user (e.g., Alice) or a script on their behalf.
     * - What it does: burns your V1 LP, withdraws TOKEN+ETH, then immediately adds them as liquidity on V2 via Router01.
     * - Step-by-step:
     *   1) Find the V1 exchange for TOKEN and read Alice’s LP balance.
     *   2) Pull all her V1 LP into this contract (requires prior approval).
     *   3) Burn the LP to withdraw TOKEN+ETH from V1 (allowing 1 wei slippage).
     *   4) Approve Router01 to spend the recovered TOKEN.
     *   5) Call addLiquidityETH on Router01, depositing TOKEN and wrapping ETH into WETH for the V2 pair, minting V2 LP to `to`.
     *   6) Refund any leftover TOKEN or ETH (dust) back to Alice.
     * - Result: Alice ends up with fresh V2 LP tokens, and any unused assets are returned to her; her V1 LP is fully burned.
     */
    function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline)
        external
        override
    {
        // 1) Locate the V1 exchange for the token being migrated.
        IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(factoryV1.getExchange(token));
        // 2) Read caller's V1 LP balance (full migration of their position).
        uint liquidityV1 = exchangeV1.balanceOf(msg.sender);
        // 3) Pull the LP tokens into this contract so we can burn them; reverts if approval missing.
        require(exchangeV1.transferFrom(msg.sender, address(this), liquidityV1), 'TRANSFER_FROM_FAILED');
        // 4) Burn V1 LP to withdraw underlying; set min amounts to 1 wei to avoid blocking on tiny slippage.
        (uint amountETHV1, uint amountTokenV1) = exchangeV1.removeLiquidity(liquidityV1, 1, 1, uint(-1));
        // 5) Approve Router01 to spend the recovered token amount for the upcoming addLiquidity call.
        TransferHelper.safeApprove(token, address(router), amountTokenV1);
        // 6) Add liquidity on V2; Router01 wraps ETH into WETH internally. Slippage is bounded by caller's mins.
        (uint amountTokenV2, uint amountETHV2,) = router.addLiquidityETH{value: amountETHV1}(
            token,
            amountTokenV1,
            amountTokenMin,
            amountETHMin,
            to,
            deadline
        );
        // 7) Refund any leftover token (if V2 consumed less than withdrawn).
        if (amountTokenV1 > amountTokenV2) {
            TransferHelper.safeApprove(token, address(router), 0); // reset allowance
            TransferHelper.safeTransfer(token, msg.sender, amountTokenV1 - amountTokenV2);
        // 8) Otherwise refund leftover ETH (only one side can have dust).
        } else if (amountETHV1 > amountETHV2) {
            // addLiquidityETH uses all of one side; remainder is safe to refund.
            TransferHelper.safeTransferETH(msg.sender, amountETHV1 - amountETHV2);
        }
    }
}
