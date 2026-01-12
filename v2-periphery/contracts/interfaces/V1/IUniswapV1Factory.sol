pragma solidity >=0.5.0;

// Legacy Uniswap V1 factory ABI (to locate V1 exchange per token).
interface IUniswapV1Factory {
    function getExchange(address) external view returns (address);
}
