pragma solidity =0.5.16;

// A library for common math operations with predictable gas and behavior.
// Design goal: keep logic small and auditable; every line is documented with intent and example outcomes.

library Math {
    /*
     * Purpose: Return the smaller of x and y.
     * Line-by-line:
     * - use the ternary expression to compare and assign.
     * Why: saves branching complexity; Solidity evaluates both sides as simple values.
     * Examples: min(3,7)=3; min(10,2)=2; min(5,5)=5 (ties return either branch, here x).
     */
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y; // picks x when strictly smaller, otherwise y
    }

    /*
     * Purpose: Integer square root via the Babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method).
     * The algorithm converges using the recurrence x_{n+1} = (x_n + y/x_n) / 2.
     * Line-by-line:
     * - if y > 3, seed z = y and x = y/2 + 1 (initial guess slightly above half).
     * - iterate while x < z: shrink z to the smaller guess and update x using the recurrence.
     * - if y is 1,2,3 we skip the loop and return 1 (since floor(sqrt(y)) == 1); if y==0 we keep z==0.
     * Why: gas-cheap integer sqrt that avoids overflow and division by zero.
     * Examples:
     *   - y=16: start z=16, x=9; loop -> z=9,x= (16/9+9)/2= (1+9)/2=5; loop -> z=5,x=(16/5+5)/2=(3+5)/2=4; loop -> z=4,x=(16/4+4)/2=(4+4)/2=4 => exit, returns 4.
     *   - y=20: start z=20,x=11; steps yield z=5,x=4 => exit with z=4 (floor sqrt).
     *   - y=0 => z remains 0.
     */
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;                    // initial upper bound guess
            uint x = y / 2 + 1;       // initial lower-ish guess avoids division by zero
            while (x < z) {           // loop until guesses converge or cross
                z = x;                // move upper bound down
                x = (y / x + x) / 2;  // Babylonian update using average of x and y/x
            }
        } else if (y != 0) {
            z = 1;                    // for y in {1,2,3} sqrt is 1
        }
    }
}
