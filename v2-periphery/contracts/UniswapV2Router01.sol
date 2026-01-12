pragma solidity =0.6.6;

// Uniswap V2 Router01
// Provides liquidity management and swap functions that wrap Uniswap V2 pairs and factory.
// Handles ETH by wrapping/unwrapping WETH and enforces deadline-based slippage protection.

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

import './libraries/UniswapV2Library.sol';
import './interfaces/IUniswapV2Router01.sol';
import './interfaces/IERC20.sol';
import './interfaces/IWETH.sol';

contract UniswapV2Router01 is IUniswapV2Router01 {
    // Address of the canonical V2 factory; immutable to save gas.
    address public immutable override factory;
    // Address of the canonical wrapped ETH contract.
    address public immutable override WETH;

    // Ensures the caller supplied a deadline that has not passed; guards users from stuck txs.
    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
        _;
    }

    constructor(address _factory, address _WETH) public {
        // Cache constructor args in immutables for cheaper subsequent reads.
        factory = _factory;
        WETH = _WETH;
    }

    receive() external payable {
        // Restrict direct ETH receipts to only come from WETH withdrawals.
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    // **** ADD LIQUIDITY ****
    /**
     * @dev Internal helper that determines how much of each token should be contributed to match pool ratios.
     * - If the pair does not exist, it is created on the factory first.
     * - Uses current reserves to compute optimal counterpart amounts with the formula:
     *   amountBOptimal = amountADesired * reserveB / reserveA  (via UniswapV2Library.quote)
     * - Enforces caller-specified minimums to protect against price movement.
     */
    function _addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin
    ) private returns (uint amountA, uint amountB) {
        // Create the pair if absent so reserves can be fetched.
        if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
            IUniswapV2Factory(factory).createPair(tokenA, tokenB);
        }
        // Read current reserves to decide the optimal contribution ratio.
        (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
        if (reserveA == 0 && reserveB == 0) {
            // Empty pool: take the user-desired amounts directly.
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            // Compute how much B is needed to pair with amountADesired at the existing price.
            uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                // Enough B provided; ensure not below user min and use the optimal pairing.
                require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                // Too little B vs A: recompute optimal A for the provided B.
                uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired); // invariant from quote math.
                require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }
    /**
     * @notice Add liquidity to a token-token pool, minting LP to `to`.
     * @dev Steps: compute optimal amounts, pull tokens into the pair, mint LP.
     */
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
        // Decide final contribution amounts based on reserves/min constraints.
        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
        // Compute deterministic pair address.
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        // Move the exact token amounts from the user to the pair.
        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
        // Mint LP tokens to the recipient; returns liquidity minted.
        liquidity = IUniswapV2Pair(pair).mint(to);
    }
    /**
     * @notice Add liquidity to a token-ETH pool, minting LP to `to`.
     * @dev Wraps ETH into WETH internally and refunds any unused ETH.
     */
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
        // Determine optimal token/ETH contributions based on pool reserves.
        (amountToken, amountETH) = _addLiquidity(
            token,
            WETH,
            amountTokenDesired,
            msg.value,
            amountTokenMin,
            amountETHMin
        );
        // Resolve pair address and transfer in the ERC20 token leg.
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
        // Wrap only the ETH actually needed, then transfer WETH to the pair.
        IWETH(WETH).deposit{value: amountETH}();
        assert(IWETH(WETH).transfer(pair, amountETH));
        // Mint LP to the recipient.
        liquidity = IUniswapV2Pair(pair).mint(to);
        // Refund unused ETH (dust) back to sender if they sent more than required.
        if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH); // refund dust eth, if any
    }

    // **** REMOVE LIQUIDITY ****
    /**
     * @notice Remove liquidity from a token-token pool, burning LP and withdrawing assets to `to`.
     * @dev Slippage is enforced via amountAMin/amountBMin.
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) public override ensure(deadline) returns (uint amountA, uint amountB) {
        // Resolve pair address.
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        // Send LP from caller to the pair contract so it can burn them.
        IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        // Burn returns the two token amounts in canonical token0/token1 order.
        (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
        // Map canonical ordering back to caller-specified tokenA/tokenB.
        (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        // Enforce minimums to guard against price movement.
        require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
        require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
    }
    /**
     * @notice Remove liquidity from a token-ETH pool, unwrapping WETH and forwarding assets.
     */
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) public override ensure(deadline) returns (uint amountToken, uint amountETH) {
        // Remove liquidity treating WETH as the second token, receiving assets here.
        (amountToken, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        // Forward ERC20 to recipient.
        TransferHelper.safeTransfer(token, to, amountToken);
        // Unwrap WETH into native ETH, then forward.
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }
    /**
     * @notice removeLiquidity with an off-chain EIP-2612 approval on the LP token.
     */
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external override returns (uint amountA, uint amountB) {
        // Approve router to spend LP using permit signature (max or exact).
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        // Proceed with standard removal.
        (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
    }
    /**
     * @notice removeLiquidityETH with permit approval on the LP token.
     */
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external override returns (uint amountToken, uint amountETH) {
        // Permit LP spend to this router.
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        // Remove liquidity and unwrap ETH.
        (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    function _swap(uint[] memory amounts, address[] memory path, address _to) private {
        // Iterate hop-by-hop along the path, pushing outputs to the next pair or final recipient.
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            // Sort tokens to know which side is token0/token1 in the pair.
            (address token0,) = UniswapV2Library.sortTokens(input, output);
            uint amountOut = amounts[i + 1];
            // Determine which token amount should be output (only one side is non-zero).
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
            // If there is another hop, send to next pair; otherwise send to final recipient.
            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
            // Execute the swap on the pair; data empty for normal swaps.
            IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }
    /**
     * @notice Swap an exact amount of input tokens for as many output tokens as possible.
     * @dev Uses Uniswap invariant math to compute expected outputs and enforces min-output slippage.
     */
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external override ensure(deadline) returns (uint[] memory amounts) {
        // Precompute all hop outputs using current reserves.
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
        // Slippage check: final amount must meet caller threshold.
        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        // Fund the first pair with the input token.
        TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
        // Cascade swaps through the path.
        _swap(amounts, path, to);
    }
    /**
     * @notice Swap as few input tokens as needed to receive an exact output amount.
     * @dev Enforces a max input cap to guard against front-running.
     */
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external override ensure(deadline) returns (uint[] memory amounts) {
        // Compute required inputs for each hop working backwards from amountOut.
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        // Slippage check: don't consume more than the caller allows.
        require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
        // Transfer the calculated input to the first pair.
        TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
        // Execute the swap chain.
        _swap(amounts, path, to);
    }
    /**
     * @notice Swap exact ETH for tokens along a path starting with WETH.
     */
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        override
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
        // Compute outputs using msg.value as input.
        amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        // Wrap ETH to WETH and fund first pair.
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
    }
    /**
     * @notice Swap tokens for an exact amount of ETH, enforcing max input.
     */
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        override
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
        // Compute required token inputs to obtain the desired ETH output.
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
        // Move tokens to first pair.
        TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
        // Perform swaps, holding ETH output in router temporarily.
        _swap(amounts, path, address(this));
        // Unwrap WETH to ETH and send to recipient.
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }
    /**
     * @notice Swap an exact amount of tokens for as much ETH as possible.
     */
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        override
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
        // Compute outputs.
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        // Transfer tokens to first pair then swap.
        TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);
        _swap(amounts, path, address(this));
        // Convert final WETH to ETH and deliver.
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }
    /**
     * @notice Swap ETH for an exact amount of tokens, refunding unused ETH.
     */
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        override
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
        // Compute how much ETH (as WETH) is required.
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
        // Wrap only the needed ETH, then fund the pair.
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
        // Refund extra ETH if caller sent more than necessary.
        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]); // refund dust eth, if any
    }

    /**
     * @notice Pure helper to quote corresponding amountB for amountA given reserves.
     * @dev Formula: amountB = amountA * reserveB / reserveA.
     */
    function quote(uint amountA, uint reserveA, uint reserveB) public pure override returns (uint amountB) {
        return UniswapV2Library.quote(amountA, reserveA, reserveB);
    }

    /**
     * @notice Compute output amount for a given input and reserves (includes 0.3% fee).
     * @dev Formula: amountOut = amountIn * 997 * reserveOut / (reserveIn * 1000 + amountIn * 997).
     */
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure override returns (uint amountOut) {
        return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
    }

    /**
     * @notice Compute required input amount for a desired output given reserves.
     * @dev Inverse of getAmountOut; note: this function delegates to library computation.
     */
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) public pure override returns (uint amountIn) {
        return UniswapV2Library.getAmountOut(amountOut, reserveIn, reserveOut);
    }

    /**
     * @notice Compute outputs across a multi-hop path for a fixed input.
     */
    function getAmountsOut(uint amountIn, address[] memory path) public view override returns (uint[] memory amounts) {
        return UniswapV2Library.getAmountsOut(factory, amountIn, path);
    }

    /**
     * @notice Compute required inputs across a multi-hop path for a fixed desired output.
     */
    function getAmountsIn(uint amountOut, address[] memory path) public view override returns (uint[] memory amounts) {
        return UniswapV2Library.getAmountsIn(factory, amountOut, path);
    }
}
