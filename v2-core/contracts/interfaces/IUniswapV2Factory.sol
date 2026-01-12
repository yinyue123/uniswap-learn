pragma solidity >=0.5.0;

// Interface for the Uniswap V2 factory that deploys pairs and manages protocol fees.
// Comments call out how each function participates in pair lifecycle.
interface IUniswapV2Factory {
    // Fired when a new pair contract is deployed and registered.
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    // Fee configuration views
    function feeTo() external view returns (address);           // Address receiving protocol fee liquidity (may be zero)
    function feeToSetter() external view returns (address);     // Address authorized to change feeTo or itself

    // Pair discovery
    function getPair(address tokenA, address tokenB) external view returns (address pair); // Returns pair address or zero
    function allPairs(uint) external view returns (address pair);                         // Pair by index in registry
    function allPairsLength() external view returns (uint);                               // Total pairs created

    // Pair creation
    function createPair(address tokenA, address tokenB) external returns (address pair);  // Deploys new pair via create2

    // Administrative setters (callable only by feeToSetter)
    function setFeeTo(address) external;           // Update fee recipient
    function setFeeToSetter(address) external;     // Transfer admin rights
}
