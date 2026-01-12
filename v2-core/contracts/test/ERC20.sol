pragma solidity =0.5.16;

import '../UniswapV2ERC20.sol';

// Simple test token inheriting the LP token implementation for fixtures.
// Each line is annotated because this contract is used heavily in tests.
contract ERC20 is UniswapV2ERC20 {
    /*
     * Purpose: Mint the full supplied amount to the deployer (test wallet).
     * Line-by-line:
     * - call parent _mint to create `_totalSupply` tokens and assign them to msg.sender.
     * Why: fixtures need an easily controllable ERC-20 for unit tests.
     * Example: deploying with _totalSupply = 1000e18 gives the deployer that many tokens.
     */
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply); // mint initial supply to deployer
    }
}
