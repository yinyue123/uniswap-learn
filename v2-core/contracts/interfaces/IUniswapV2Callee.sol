pragma solidity >=0.5.0;

// Callback interface for contracts using Uniswap V2 flash swaps.
// Pairs invoke this hook if swap() is called with non-empty data.
interface IUniswapV2Callee {
    /*
     * Called after tokens are optimistically sent to `sender`.
     * Implementations must return the borrowed amounts plus fee within the same transaction.
     * - sender: original msg.sender of swap
     * - amount0 / amount1: tokens sent out by the pair
     * - data: arbitrary payload forwarded from swap caller
     */
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
