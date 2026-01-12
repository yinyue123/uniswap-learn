pragma solidity >=0.5.0;

// Legacy Uniswap V1 exchange ABI (used by migrator and examples).
interface IUniswapV1Exchange {
    function balanceOf(address owner) external view returns (uint);
    function transferFrom(address from, address to, uint value) external returns (bool);
    // Burn V1 LP and withdraw underlying token and ETH.
    function removeLiquidity(uint, uint, uint, uint) external returns (uint, uint);
    // Swap token -> ETH with input amount and min ETH out.
    function tokenToEthSwapInput(uint, uint, uint) external returns (uint);
    // Swap ETH -> token with min token out.
    function ethToTokenSwapInput(uint, uint) external payable returns (uint);
}
