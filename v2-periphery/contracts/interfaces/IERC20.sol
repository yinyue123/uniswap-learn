pragma solidity >=0.5.0;

// Minimal ERC20 interface used by the periphery.
interface IERC20 {
    // Emitted on approvals: owner allows spender to spend `value`.
    event Approval(address indexed owner, address indexed spender, uint value);
    // Emitted on transfers from -> to for `value` tokens.
    event Transfer(address indexed from, address indexed to, uint value);

    // Metadata getters.
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);

    // Supply and accounting.
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    // State-changing operations.
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}
