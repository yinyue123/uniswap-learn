pragma solidity =0.6.6;

// Example: expose liquidity valuation helpers from UniswapV2LiquidityMathLibrary.
import '../libraries/UniswapV2LiquidityMathLibrary.sol';

contract ExampleComputeLiquidityValue {
    using SafeMath for uint256;

    // Factory address used by the library to fetch pair data.
    address public immutable factory;

    constructor(address factory_) public {
        factory = factory_;
    }

    /**
     * @notice Simulate post-arbitrage reserves given an externally observed true price.
     * @dev Delegates to library; useful for UIs estimating invariant shifts.
     */
    function getReservesAfterArbitrage(
        address tokenA,
        address tokenB,
        uint256 truePriceTokenA,
        uint256 truePriceTokenB
    ) external view returns (uint256 reserveA, uint256 reserveB) {
        return UniswapV2LiquidityMathLibrary.getReservesAfterArbitrage(
            factory,
            tokenA,
            tokenB,
            truePriceTokenA,
            truePriceTokenB
        );
    }

    /**
     * @notice Compute current value of an LP position using live reserves and fee-on status.
     * @dev Returns token amounts proportional to `liquidityAmount / totalSupply`.
     */
    function getLiquidityValue(
        address tokenA,
        address tokenB,
        uint256 liquidityAmount
    ) external view returns (
        uint256 tokenAAmount,
        uint256 tokenBAmount
    ) {
        return UniswapV2LiquidityMathLibrary.getLiquidityValue(
            factory,
            tokenA,
            tokenB,
            liquidityAmount
        );
    }

    /**
     * @notice Compute LP value after hypothetically arbitraging to the provided true price.
     * @dev This is more manipulation-resistant than raw reserve ratios.
     */
    function getLiquidityValueAfterArbitrageToPrice(
        address tokenA,
        address tokenB,
        uint256 truePriceTokenA,
        uint256 truePriceTokenB,
        uint256 liquidityAmount
    ) external view returns (
        uint256 tokenAAmount,
        uint256 tokenBAmount
    ) {
        return UniswapV2LiquidityMathLibrary.getLiquidityValueAfterArbitrageToPrice(
            factory,
            tokenA,
            tokenB,
            truePriceTokenA,
            truePriceTokenB,
            liquidityAmount
        );
    }

    /**
     * @notice Utility to measure the gas cost of the arbitrage-aware valuation call.
     */
    function getGasCostOfGetLiquidityValueAfterArbitrageToPrice(
        address tokenA,
        address tokenB,
        uint256 truePriceTokenA,
        uint256 truePriceTokenB,
        uint256 liquidityAmount
    ) external view returns (
        uint256
    ) {
        uint gasBefore = gasleft();
        UniswapV2LiquidityMathLibrary.getLiquidityValueAfterArbitrageToPrice(
            factory,
            tokenA,
            tokenB,
            truePriceTokenA,
            truePriceTokenB,
            liquidityAmount
        );
        uint gasAfter = gasleft();
        return gasBefore - gasAfter;
    }
}
