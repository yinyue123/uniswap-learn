pragma solidity =0.5.16;

// A library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format)).
// Format: UQ112x112 packs 112 fractional bits and 112 integer bits.
// Range: [0, 2**112 - 1] for the integer part; smallest step is 1 / 2**112.
// Example encoding:
// - encode(1)   = 1 * 2**112
// - encode(5.5) is not allowed directly (inputs are uint112), but multiplying 5.5 by 2**112 gives the fixed-point representation.

library UQ112x112 {
    uint224 constant Q112 = 2**112;

    /*
     * Purpose: Promote a uint112 to UQ112x112 by left-shifting 112 bits (multiplying by 2**112).
     * Line-by-line:
     * - cast y to uint224 and multiply by Q112 to allocate the fractional slot.
     * Why: keeps full precision when later divided by another uint to form ratios.
     * Examples: encode(2) => 2 * 2**112; encode(0) => 0.
     */
    function encode(uint112 y) internal pure returns (uint224 z) {
        z = uint224(y) * Q112; // multiply by scaling constant; fits because y is capped at 112 bits
    }

    /*
     * Purpose: Divide a UQ112x112 fixed-point number by an integer while preserving scale.
     * Line-by-line:
     * - simple integer division by the uint224-cast divisor.
     * Why: downstream math relies on staying in fixed-point form without losing fractional bits.
     * Examples:
     *   - If x = encode(10) = 10 * 2**112, uqdiv(x, 2) = 5 * 2**112 (represents 5.0).
     *   - If x = encode(3), uqdiv(x, 4) = (3/4) * 2**112 (0.75 in real terms).
     */
    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
        z = x / uint224(y); // safe because y is non-zero in calling contexts; keeps Q112 scaling
    }
}
