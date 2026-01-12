pragma solidity >=0.5.0;

// Minimal WETH interface used by routers and examples.
interface IWETH {
    // Wrap ETH into WETH.
    function deposit() external payable;
    // ERC20-style transfer.
    function transfer(address to, uint value) external returns (bool);
    // Unwrap WETH into ETH.
    function withdraw(uint) external;
}
