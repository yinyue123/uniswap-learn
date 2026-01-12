pragma solidity =0.5.16;

// A library for overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math).
// Each helper mirrors Solidity's built-ins but reverts on overflow/underflow instead of wrapping.
// Example outcomes:
// - add(2, 3) => 5; add(2**256-1, 1) reverts.
// - sub(5, 2) => 3; sub(2, 5) reverts.
// - mul(7, 8) => 56; mul(2**200, 2**80) reverts because the 256-bit product would overflow.

library SafeMath {
    /*
     * Purpose: Return x + y while reverting on uint overflow.
     * Line-by-line:
     * - compute z = x + y and simultaneously check z >= x; if false, addition wrapped and we revert.
     * Why: Solidity 0.5 does not check overflows; this guard makes math total-order safe for token balances.
     */
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow'); // z holds the sum; the comparison detects wrap-around
    }

    /*
     * Purpose: Return x - y while reverting on uint underflow.
     * Line-by-line:
     * - compute z = x - y and assert z <= x; if y > x the subtraction wrapped, proving underflow.
     * Why: Balance/accounting math must not silently wrap; this mirrors "checked subtract" semantics.
     */
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow'); // ensures y is not greater than x
    }

    /*
     * Purpose: Return x * y while reverting on uint overflow.
     * Line-by-line:
     * - if y == 0 we short-circuit because x*0 == 0 cannot overflow.
     * - otherwise compute z = x * y and assert (z / y == x); if multiplication wrapped, division loses information.
     * Why: Products appear in invariant checks (e.g., constant product k); correctness requires full-width safety.
     * Examples: mul(3,4)=12; mul(2**200, 2**60) succeeds; mul(2**200, 2**80) overflows and reverts because (x*y)/y != x.
     */
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow'); // if y!=0 ensure division recovers x
    }
}
