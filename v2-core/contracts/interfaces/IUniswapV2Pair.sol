pragma solidity >=0.5.0;

// Interface for Uniswap V2 pair contracts (LP tokens + AMM core).
// Comments describe the role of each primitive to aid integrators and auditors.
interface IUniswapV2Pair {
    // ERC-20 compatible events for LP token transfers/approvals
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    // Metadata views (all constant for a deployed pair)
    function name() external pure returns (string memory);     // LP token name ("Uniswap V2")
    function symbol() external pure returns (string memory);   // LP ticker ("UNI-V2")
    function decimals() external pure returns (uint8);         // Fixed 18 decimals

    // ERC-20 supply/balance/allowance views
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    // ERC-20 actions
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    // Permit (EIP-2612) primitives
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    // AMM lifecycle events
    event Mint(address indexed sender, uint amount0, uint amount1); // Liquidity added
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to); // Liquidity removed
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    ); // Token swap executed
    event Sync(uint112 reserve0, uint112 reserve1); // Reserves updated to balances

    // Immutable + reserve views
    function MINIMUM_LIQUIDITY() external pure returns (uint);  // Amount locked forever to avoid divide-by-zero
    function factory() external view returns (address);         // Factory that deployed this pair
    function token0() external view returns (address);          // Sorted smaller token address
    function token1() external view returns (address);          // Sorted larger token address
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast); // Cached reserves + last update time
    function price0CumulativeLast() external view returns (uint); // Accumulated price0 * time in UQ112x112
    function price1CumulativeLast() external view returns (uint); // Accumulated price1 * time in UQ112x112
    function kLast() external view returns (uint);                // Last recorded reserve0 * reserve1 after a liquidity event

    // Core AMM actions
    function mint(address to) external returns (uint liquidity);                                       // Add liquidity and mint LP
    function burn(address to) external returns (uint amount0, uint amount1);                           // Remove liquidity and transfer tokens
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;         // Swap tokens; data triggers flash callback
    function skim(address to) external;                                                                // Sweep dust above reserves
    function sync() external;                                                                          // Re-sync reserves to balances

    // Initialization hook called once from factory
    function initialize(address, address) external;
}
