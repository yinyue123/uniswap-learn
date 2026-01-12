pragma solidity =0.5.16;

import './interfaces/IUniswapV2Pair.sol';
import './UniswapV2ERC20.sol';
import './libraries/Math.sol';
import './libraries/UQ112x112.sol';
import './interfaces/IERC20.sol';
import './interfaces/IUniswapV2Factory.sol';
import './interfaces/IUniswapV2Callee.sol';

// Uniswap V2 pair = constant-product AMM + ERC-20 LP token.
// Comments give line-by-line intent, math formulas, and examples where helpful.
contract UniswapV2Pair is IUniswapV2Pair, UniswapV2ERC20 {
    using SafeMath  for uint;
    using UQ112x112 for uint224;

    // MINIMUM_LIQUIDITY is permanently locked in the first mint to prevent division-by-zero and price manipulation at init.
    uint public constant MINIMUM_LIQUIDITY = 10**3;
    // ERC-20 transfer selector for low-level calls (bytes4(keccak256("transfer(address,uint256)")))
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    address public factory; // Factory that deployed this pair
    address public token0;  // Sorted token with lower address
    address public token1;  // Sorted token with higher address

    // Cached reserves use packed storage to save gas; updated via _update().
    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves
    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves

    // Cumulative prices for TWAP oracles (sum of price * seconds)
    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

    // Reentrancy guard
    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'UniswapV2: LOCKED'); // ensure not already entered
        unlocked = 0;                                // lock
        _;
        unlocked = 1;                                // unlock
    }

    /*
     * Purpose: Return cached reserves and last timestamp in a single read.
     * Line-by-line:
     * - assign storage reserves to local return variables to save gas for callers.
     * Why: external callers avoid multiple SLOADs when needing all values.
     */
    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    /*
     * Purpose: Perform ERC-20 transfer with return-value compatibility checks.
     * Line-by-line:
     * - call token.transfer(to, value) via selector to support tokens that return bool or nothing.
     * - require the call succeeded AND (no return data OR abi-decodes to true).
     * Why: shields against non-compliant tokens that might revert silently or return false.
     */
    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value)); // perform call
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED'); // validate success flag / return
    }

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    /*
     * Purpose: Set factory address on deployment.
     * Line-by-line:
     * - factory = msg.sender (the factory contract).
     * Why: immutable binding ensures only the factory is recognized as deployer/admin of initialization.
     */
    constructor() public {
        factory = msg.sender; // remember deploying factory
    }

    /*
     * Purpose: Initialize token addresses (called once by factory).
     * Line-by-line:
     * - require caller is factory for safety.
     * - store sorted token addresses.
     * Why: separates deployment from initialization to support create2 deterministic addresses.
     */
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
        token0 = _token0; // lower address token
        token1 = _token1; // higher address token
    }

    /*
     * Purpose: Update reserves and cumulative prices.
     * Inputs:
     * - balance0/balance1: current token balances in the pair
     * - _reserve0/_reserve1: previous reserves cached for calculations
     * Line-by-line:
     * - validate balances fit into uint112 to preserve packing.
     * - grab current block timestamp mod 2**32 to keep 32-bit storage.
     * - compute timeElapsed; rely on uint32 overflow to wrap naturally (desired).
     * - if time progressed and reserves non-zero, update cumulative prices:
     *     price0CumulativeLast += (reserve1/reserve0) * timeElapsed
     *     price1CumulativeLast += (reserve0/reserve1) * timeElapsed
     *   where division uses UQ112x112 fixed-point to preserve precision.
     * - write reserves to storage and emit Sync.
     * Why: keeps oracle accumulators monotonic and reserves consistent with balances after every liquidity or swap.
     * Example: if reserve0=5, reserve1=10, timeElapsed=2 => price0Cumulative += (10/5)*2 = 4 (scaled in Q112).
     */
    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
        uint32 blockTimestamp = uint32(block.timestamp % 2**32); // truncate to 32 bits
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            // * never overflows, and + overflow is desired
            price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
            price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        }
        reserve0 = uint112(balance0); // sync reserve0
        reserve1 = uint112(balance1); // sync reserve1
        blockTimestampLast = blockTimestamp; // record time
        emit Sync(reserve0, reserve1);
    }

    /*
     * Purpose: Mint protocol fee liquidity when enabled.
     * Math: fee liquidity = totalSupply * (sqrt(k) - sqrt(kLast)) / (5*sqrt(k) + sqrt(kLast))
     * Derivation yields protocol cut of 1/6th of LP growth in sqrt(k).
     * Line-by-line:
     * - read feeTo from factory; feeOn if non-zero.
     * - cache kLast (previous reserve product) for gas.
     * - if feeOn and kLast != 0:
     *     * compute rootK = sqrt(reserve0*reserve1), rootKLast = sqrt(kLast).
     *     * if growth occurred (rootK > rootKLast), compute liquidity per formula.
     *     * mint liquidity to feeTo if >0.
     * - else if feeOff and kLast != 0, reset kLast to 0 to stop fee accrual.
     * Why: protocol takes a share of fees only when configured; formula preserves LP share proportions.
     * Example: reserves grow from (100,100) to (121,121):
     *   sqrt(kLast)=100, sqrt(k)=121, totalSupply=S.
     *   liquidity = S*(21)/(5*121+100) ≈ S*21/705 ≈ S*0.0298.
     */
    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
        address feeTo = IUniswapV2Factory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1)); // sqrt(current k)
                uint rootKLast = Math.sqrt(_kLast);                     // sqrt(previous k)
                if (rootK > rootKLast) {
                    uint numerator = totalSupply.mul(rootK.sub(rootKLast));        // S * (Δsqrt(k))
                    uint denominator = rootK.mul(5).add(rootKLast);                // 5*rootK + rootKLast
                    uint liquidity = numerator / denominator;                      // formula result
                    if (liquidity > 0) _mint(feeTo, liquidity);                    // mint protocol fee
                }
            }
        } else if (_kLast != 0) {
            kLast = 0; // reset when turning off fees
        }
    }

    /*
     * Purpose: Add liquidity and mint LP tokens to `to`.
     * Flow (line-by-line):
     * 1) Read cached reserves via getReserves for calculations.
     * 2) Read current token balances to see how many tokens were sent in.
     * 3) Compute amounts added: amount0 = balance0 - _reserve0, amount1 = balance1 - _reserve1.
     * 4) Handle protocol fee via _mintFee (may mint to feeTo and update totalSupply).
     * 5) If first liquidity (totalSupply==0):
     *      liquidity = sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY (locks floor amount).
     *      Mint MINIMUM_LIQUIDITY to address(0) to make it unspendable.
     *    Else:
     *      liquidity = min(amount0 * S / _reserve0, amount1 * S / _reserve1)
     *      (keeps proportional share where S = current totalSupply).
     * 6) Require liquidity > 0 to avoid zero-mint edge cases.
     * 7) Mint LP tokens to `to`.
     * 8) Update reserves to new balances and set kLast if feeOn.
     * 9) Emit Mint event describing token contributions.
     * Why: follows constant product invariant and proportional share rules so each LP receives fair supply.
     * Example first mint: amount0=1_000_000, amount1=2_000_000 => liquidity ≈ sqrt(2e12) - 1000 ≈ 1_414_213 - 1000 = 1_413_213 LP (MINIMUM_LIQUIDITY safely absorbed).
     * Example subsequent mint: reserves (500,500), S=1000 LP, deposit (50,0) would mint min(50*1000/500=100, 0*1000/500=0)=0 => revert, encouraging balanced deposits.
     */
    function mint(address to) external lock returns (uint liquidity) {
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // 1) load reserves
        uint balance0 = IERC20(token0).balanceOf(address(this)); // 2) current balance0
        uint balance1 = IERC20(token1).balanceOf(address(this)); // 2) current balance1
        uint amount0 = balance0.sub(_reserve0);                  // 3) net token0 added
        uint amount1 = balance1.sub(_reserve1);                  // 3) net token1 added

        bool feeOn = _mintFee(_reserve0, _reserve1);             // 4) apply protocol fee if enabled
        uint _totalSupply = totalSupply;                         // cache supply (may change if fee minted)
        if (_totalSupply == 0) {
            liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY); // 5a) initial liquidity formula
            _mint(address(0), MINIMUM_LIQUIDITY);                                // lock floor to avoid complete withdrawal
        } else {
            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1); // 5b) proportional mint
        }
        require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');      // 6) must be positive
        _mint(to, liquidity);                                                    // 7) mint LP to provider

        _update(balance0, balance1, _reserve0, _reserve1);                       // 8) sync reserves
        if (feeOn) kLast = uint(reserve0).mul(reserve1);                         // record new k if fee accrual active
        emit Mint(msg.sender, amount0, amount1);                                 // 9) log mint
    }

    /*
     * Purpose: Redeem LP tokens for underlying tokens.
     * Flow:
     * 1) Load reserves and token addresses (cached for gas).
     * 2) Read current balances and LP tokens held by pair (liquidity to burn is held by pair contract).
     * 3) Apply protocol fee if needed via _mintFee.
     * 4) Compute outputs pro-rata: amount0 = liquidity * balance0 / totalSupply; same for amount1.
     *    Using balances (not reserves) accounts for fees accrued in the block.
     * 5) Require both amounts > 0.
     * 6) Burn LP tokens from pair's balance.
     * 7) Transfer tokens to recipient.
     * 8) Re-read balances (post-transfer) and update reserves; set kLast if feeOn.
     * 9) Emit Burn event.
     * Why: preserves proportional ownership and ensures reserves stay in sync with actual balances after redemption.
     * Example: reserves (100,200), balances equal, totalSupply=100 LP, burning 10 LP => amount0=10*100/100=10, amount1=20.
     */
    function burn(address to) external lock returns (uint amount0, uint amount1) {
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // 1) cached reserves
        address _token0 = token0;                                // 1) cached token0
        address _token1 = token1;                                // 1) cached token1
        uint balance0 = IERC20(_token0).balanceOf(address(this)); // 2) current balances
        uint balance1 = IERC20(_token1).balanceOf(address(this));
        uint liquidity = balanceOf[address(this)];                // 2) LP tokens to burn (must be transferred to pair first)

        bool feeOn = _mintFee(_reserve0, _reserve1);              // 3) protocol fee handling
        uint _totalSupply = totalSupply;                          // cache supply after fee mint
        amount0 = liquidity.mul(balance0) / _totalSupply;         // 4) pro-rata token0
        amount1 = liquidity.mul(balance1) / _totalSupply;         // 4) pro-rata token1
        require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED'); // 5) ensure non-zero
        _burn(address(this), liquidity);                          // 6) destroy LP tokens
        _safeTransfer(_token0, to, amount0);                      // 7) send token0
        _safeTransfer(_token1, to, amount1);                      // 7) send token1
        balance0 = IERC20(_token0).balanceOf(address(this));      // 8) updated balances
        balance1 = IERC20(_token1).balanceOf(address(this));

        _update(balance0, balance1, _reserve0, _reserve1);        // 8) sync reserves
        if (feeOn) kLast = uint(reserve0).mul(reserve1);          // maintain kLast when feeOn
        emit Burn(msg.sender, amount0, amount1, to);              // 9) log burn
    }

    /*
     * Purpose: Swap tokens while enforcing constant-product invariant with 0.3% fee.
     * Flow:
     * 1) Validate requested outputs are non-zero and less than current reserves.
     * 2) Transfer outputs optimistically to `to`; optional callback for flash swaps when data is non-empty.
     * 3) After transfers/callback, read current balances to infer inputs actually provided.
     *    amount0In = balance0 - (_reserve0 - amount0Out); same for token1.
     * 4) Require at least one positive input.
     * 5) Apply fee-adjusted invariant check:
     *      (balance0*1000 - amount0In*3) * (balance1*1000 - amount1In*3) >= reserve0*reserve1*1000^2
     *    Explanation:
     *      - Multiply balances by 1000 to represent fee denominator.
     *      - Subtract amountIn*3 (0.3% of input) to simulate taking fee; effectively ensures:
     *        balance0Adjusted * balance1Adjusted >= reserve0 * reserve1 * 1000^2
     *      - Equivalent to (reserve0 + amount0In*997/1000) * (reserve1 + amount1In*997/1000) >= reserve0*reserve1
     * 6) Update reserves to new balances and emit Swap event with in/out amounts.
     * Why: using post-transfer balances makes swaps agnostic to transfer-fee tokens; invariant check enforces fee capture.
     * Example:
     *   reserves (1000,1000), user wants 100 token0 out and sends token1 in.
     *   After transfer: amount0Out=100, balance0=900, balance1= ? must satisfy invariant; solving yields ~111.23 token1In (including fee).
     */
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
        require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');        // 1) need some output
        (uint112 _reserve0, uint112 _reserve1,) = getReserves();                                   // 1) cached reserves
        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY'); // 1) outputs must be available

        uint balance0;
        uint balance1;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _token0 = token0;
        address _token1 = token1;
        require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');                          // 2) prevent sending to tokens themselves
        if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out);                                // 2) send token0
        if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);                                // 2) send token1
        if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data); // 2) optional flash swap callback
        balance0 = IERC20(_token0).balanceOf(address(this));                                       // 3) updated balance0
        balance1 = IERC20(_token1).balanceOf(address(this));                                       // 3) updated balance1
        }
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0; // 3) inferred token0 input
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0; // 3) inferred token1 input
        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');              // 4) must bring something in
        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
        uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));                            // 5) apply 0.3% fee on token0 input
        uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));                            // 5) apply 0.3% fee on token1 input
        require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K'); // 5) invariant check
        }

        _update(balance0, balance1, _reserve0, _reserve1);                                            // 6) sync reserves
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);                      // 6) log swap
    }

    /*
     * Purpose: Sweep any token balances above recorded reserves to `to`.
     * Line-by-line:
     * - cache token addresses.
     * - transfer (currentBalance - reserve) for each token to recipient.
     * Why: handles accidental token transfers or fee-on-transfer tokens that left dust.
     */
    function skim(address to) external lock {
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
    }

    /*
     * Purpose: Force reserves to match current balances.
     * Line-by-line:
     * - call _update with live balances and existing reserve cache.
     * Why: resynchronizes when tokens are sent directly without calling swap/mint/burn.
     */
    function sync() external lock {
        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
    }
}
