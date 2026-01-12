pragma solidity >=0.5.0;

// Minimal ERC-20 surface used by the core contracts.
// Each declaration mirrors the standard; comments describe expected behavior and intent.
interface IERC20 {
    // Emitted when `owner` authorizes `spender` for `value` tokens.
    event Approval(address indexed owner, address indexed spender, uint value);
    // Emitted on token moves between addresses, including mints (from = 0) and burns (to = 0).
    event Transfer(address indexed from, address indexed to, uint value);

    // Token metadata helpers
    function name() external view returns (string memory);     // Human-readable token name
    function symbol() external view returns (string memory);   // Ticker-like shorthand
    function decimals() external view returns (uint8);         // Display precision (typically 18)

    // Supply and balance inspection
    function totalSupply() external view returns (uint);       // Current circulating supply
    function balanceOf(address owner) external view returns (uint); // Balance for an account
    function allowance(address owner, address spender) external view returns (uint); // Remaining approved amount

    // State-changing actions
    function approve(address spender, uint value) external returns (bool);             // Set allowance to value
    function transfer(address to, uint value) external returns (bool);                 // Move tokens from caller to recipient
    function transferFrom(address from, address to, uint value) external returns (bool); // Move tokens via allowance
}
