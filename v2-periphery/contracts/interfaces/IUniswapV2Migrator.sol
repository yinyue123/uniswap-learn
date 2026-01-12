pragma solidity >=0.5.0;

// Interface for migrating Uniswap V1 LP to V2.
interface IUniswapV2Migrator {
    /**
     * @notice Burn V1 LP for `token/ETH`, then add equivalent V2 liquidity.
     * @param token ERC20 paired with ETH in the V1 exchange.
     * @param amountTokenMin Minimum token accepted when adding to V2 (slippage guard).
     * @param amountETHMin Minimum ETH accepted when adding to V2.
     * @param to Recipient of the newly minted V2 LP tokens.
     * @param deadline Expiration timestamp to prevent stale execution.
     */
    function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external;
}
