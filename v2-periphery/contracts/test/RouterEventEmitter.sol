pragma solidity =0.6.6;

// Test helper that delegates swap calls to a router and emits the returned amounts.
import '../interfaces/IUniswapV2Router01.sol';

contract RouterEventEmitter {
    // Exposes the amounts array for inspection in tests.
    event Amounts(uint[] amounts);

    receive() external payable {}

    // Each wrapper delegates to the provided router and emits the decoded amounts.
    function swapExactTokensForTokens(
        address router,
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IUniswapV2Router01(router).swapExactTokensForTokens.selector, amountIn, amountOutMin, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapTokensForExactTokens(
        address router,
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IUniswapV2Router01(router).swapTokensForExactTokens.selector, amountOut, amountInMax, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapExactETHForTokens(
        address router,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IUniswapV2Router01(router).swapExactETHForTokens.selector, amountOutMin, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapTokensForExactETH(
        address router,
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IUniswapV2Router01(router).swapTokensForExactETH.selector, amountOut, amountInMax, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapExactTokensForETH(
        address router,
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IUniswapV2Router01(router).swapExactTokensForETH.selector, amountIn, amountOutMin, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }

    function swapETHForExactTokens(
        address router,
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable {
        (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
            IUniswapV2Router01(router).swapETHForExactTokens.selector, amountOut, path, to, deadline
        ));
        assert(success);
        emit Amounts(abi.decode(returnData, (uint[])));
    }
}
