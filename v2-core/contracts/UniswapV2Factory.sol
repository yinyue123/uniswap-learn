pragma solidity =0.5.16;

import './interfaces/IUniswapV2Factory.sol';
import './UniswapV2Pair.sol';

// Factory deploys and tracks all Uniswap V2 pairs. Comments provide step-by-step rationale for each action.
contract UniswapV2Factory is IUniswapV2Factory {
    address public feeTo;        // Recipient of protocol fee liquidity (set by admin)
    address public feeToSetter;  // Admin authorized to change feeTo and this variable

    mapping(address => mapping(address => address)) public getPair; // tokenA => tokenB => pair address (both directions)
    address[] public allPairs;                                      // Registry of all created pairs

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    /*
     * Purpose: Initialize the factory with an admin address.
     * Line-by-line:
     * - store _feeToSetter in state.
     * Why: centralizes authorization for fee configuration.
     */
    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter; // set admin
    }

    /*
     * Purpose: Return number of pairs created.
     * Implementation: expose length of allPairs array.
     * Why: useful for off-chain enumeration and consistency with interface.
     */
    function allPairsLength() external view returns (uint) {
        return allPairs.length; // direct length read, O(1)
    }

    /*
     * Purpose: Deploy a new pair for tokenA/tokenB using CREATE2 to a deterministic address.
     * Line-by-line:
     * - ensure token addresses differ; identical tokens would break pricing.
     * - sort tokens so token0 < token1 for determinism in mappings and salts.
     * - require token0 is non-zero to avoid deploying to zero address pair.
     * - ensure mapping entry empty to prevent duplicate pairs (single direction check is enough due to symmetry).
     * - load pair creation bytecode via `type(UniswapV2Pair).creationCode`.
     * - compute salt = keccak256(token0, token1) so address = keccak256(0xff || factory || salt || bytecodeHash).
     * - assembly create2 deploys the pair with deterministic address (value = 0, bytecode pointer skips length word).
     * - call initialize(token0, token1) on pair to set immutable addresses.
     * - populate getPair mapping both directions for quick lookup.
     * - push pair to allPairs registry.
     * - emit PairCreated with index (allPairs.length after push).
     * Why: deterministic addresses enable CREATE2 pre-computation used in SDKs and on-chain checks.
     * Example salt/address: for tokens A,B sorted to (A,B), salt = keccak256(abi.encodePacked(A,B)); any chain node can precompute pair.
     */
    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES'); // reject same token
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); // sort addresses
        require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');                                 // disallow zero address token
        require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(UniswapV2Pair).creationCode; // creation bytecode
        bytes32 salt = keccak256(abi.encodePacked(token0, token1)); // unique salt per unordered pair
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt) // deploy with deterministic address
        }
        IUniswapV2Pair(pair).initialize(token0, token1); // set token addresses
        getPair[token0][token1] = pair;                  // map forward direction
        getPair[token1][token0] = pair;                  // populate mapping in the reverse direction
        allPairs.push(pair);                             // record new pair
        emit PairCreated(token0, token1, pair, allPairs.length); // notify listeners with total count
    }

    /*
     * Purpose: Update fee recipient.
     * Line-by-line:
     * - require caller is feeToSetter admin.
     * - write new address to feeTo.
     * Why: restricts fee configuration to trusted party (governance).
     */
    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN'); // only admin
        feeTo = _feeTo;                                             // update recipient
    }

    /*
     * Purpose: Transfer admin rights.
     * Line-by-line:
     * - require caller is current admin.
     * - set feeToSetter to new admin.
     * Why: enables governance handoff or multisig upgrades.
     */
    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN'); // only admin
        feeToSetter = _feeToSetter;                                 // update admin
    }
}
