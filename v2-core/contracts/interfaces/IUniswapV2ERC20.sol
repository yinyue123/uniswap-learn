pragma solidity >=0.5.0;

// ERC-20-compatible surface exposed by Uniswap V2 liquidity tokens, plus EIP-2612 permit support.
// Each function/event is documented with its role to make integration explicit.
interface IUniswapV2ERC20 {
    // Standard ERC-20 events
    event Approval(address indexed owner, address indexed spender, uint value); // Emitted when allowance changes
    event Transfer(address indexed from, address indexed to, uint value);        // Emitted on token moves (mint/burn included)

    // Metadata: constant values for LP token identity
    function name() external pure returns (string memory);     // Should return "Uniswap V2"
    function symbol() external pure returns (string memory);   // Should return "UNI-V2"
    function decimals() external pure returns (uint8);         // Fixed at 18

    // Supply and balance views
    function totalSupply() external view returns (uint);       // Total LP tokens in circulation
    function balanceOf(address owner) external view returns (uint); // LP balance for an account
    function allowance(address owner, address spender) external view returns (uint); // Remaining delegated spending power

    // Mutating ERC-20 actions
    function approve(address spender, uint value) external returns (bool);      // Set spender's allowance from caller
    function transfer(address to, uint value) external returns (bool);          // Send LP tokens from caller to `to`
    function transferFrom(address from, address to, uint value) external returns (bool); // Spend allowance to move tokens

    // EIP-712/EIP-2612 permit primitives
    function DOMAIN_SEPARATOR() external view returns (bytes32); // Typed data domain hash bound to chainId + contract
    function PERMIT_TYPEHASH() external pure returns (bytes32);  // Constant struct hash for Permit
    function nonces(address owner) external view returns (uint); // Monotonic counter consumed by permits

    // Gasless approval using signatures
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external; // Sets allowance via off-chain signature prior to `deadline`
}
