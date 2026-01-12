pragma solidity =0.5.16;

import './interfaces/IUniswapV2ERC20.sol';
import './libraries/SafeMath.sol';

// Minimal ERC-20 implementation used by Uniswap V2 LP tokens with EIP-2612 permit.
// Every function is annotated with what it does, how it does it, and why the approach is chosen.
contract UniswapV2ERC20 is IUniswapV2ERC20 {
    using SafeMath for uint;

    // Immutable token identity
    string public constant name = 'Uniswap V2';   // Human-readable name
    string public constant symbol = 'UNI-V2';     // Short symbol used by wallets
    uint8 public constant decimals = 18;          // Precision matches ETH and most ERC-20s
    // Supply and balances
    uint  public totalSupply;                     // Tracks total LP supply; adjusted on mint/burn
    mapping(address => uint) public balanceOf;    // Account balances
    mapping(address => mapping(address => uint)) public allowance; // Allowance matrix owner => spender => amount

    // EIP-712/EIP-2612 domain data
    bytes32 public DOMAIN_SEPARATOR;                                                  // Bound to chainId + contract address
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9; // Struct hash for permits
    mapping(address => uint) public nonces;                                           // Per-owner nonce to prevent replay

    // ERC-20 events
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    /*
     * Purpose: Construct domain separator once using current chain id and contract address.
     * Line-by-line:
     * - declare local chainId; populate via inline assembly `chainid` opcode.
     * - compute DOMAIN_SEPARATOR as keccak256 of the EIP-712 domain struct encoding.
     * Why: domain separator ties signatures to chain + contract, preventing replay across forks/contracts.
     */
    constructor() public {
        uint chainId;            // will hold current chain id
        assembly {
            chainId := chainid   // read chain id from EVM (added in Byzantium)
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'), // domain type hash
                keccak256(bytes(name)),   // hashed name field
                keccak256(bytes('1')),    // version string hashed (fixed at "1")
                chainId,                  // binds to specific chain
                address(this)             // binds to this contract instance
            )
        );
    }

    /*
     * Purpose: Mint LP tokens to `to`.
     * Line-by-line:
     * - increase totalSupply by value using SafeMath to catch overflow (formula: newSupply = oldSupply + value).
     * - increase recipient balance likewise (newBalance = oldBalance + value).
     * - emit Transfer from address(0) to signal mint per ERC-20 convention.
     * Why: internal helper used by pair contract to create LP tokens safely.
     */
    function _mint(address to, uint value) internal {
        totalSupply = totalSupply.add(value);      // update global supply
        balanceOf[to] = balanceOf[to].add(value);  // credit recipient
        emit Transfer(address(0), to, value);      // emit mint event
    }

    /*
     * Purpose: Burn LP tokens from `from`.
     * Line-by-line:
     * - decrement sender balance (ensuring underflow protection).
     * - decrement total supply accordingly.
     * - emit Transfer to address(0) to mark burn.
     * Why: internal helper used when liquidity is removed.
     */
    function _burn(address from, uint value) internal {
        balanceOf[from] = balanceOf[from].sub(value); // debit sender
        totalSupply = totalSupply.sub(value);         // lower supply
        emit Transfer(from, address(0), value);       // emit burn event
    }

    /*
     * Purpose: Set allowance for spender on behalf of owner.
     * Line-by-line:
     * - write allowance mapping to new value.
     * - emit Approval event as per ERC-20.
     * Why: shared by approve() and permit() to keep logic consistent.
     */
    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;            // store allowance
        emit Approval(owner, spender, value);         // notify off-chain listeners
    }

    /*
     * Purpose: Move tokens between accounts.
     * Line-by-line:
     * - subtract value from sender using SafeMath to catch insufficient balance.
     * - add value to recipient.
     * - emit Transfer event.
     * Why: internal primitive reused by transfer/transferFrom to avoid duplication.
     */
    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value); // debit sender
        balanceOf[to] = balanceOf[to].add(value);     // credit receiver
        emit Transfer(from, to, value);               // log move
    }

    /*
     * Purpose: Public ERC-20 approve.
     * Implementation: delegate to _approve using msg.sender as owner and return true to signal success.
     * Why: standard pattern expected by ERC-20 tooling.
     */
    function approve(address spender, uint value) external returns (bool) {
        _approve(msg.sender, spender, value); // set allowance
        return true;                          // signal success per ERC-20
    }

    /*
     * Purpose: Public ERC-20 transfer.
     * Implementation: call _transfer with msg.sender as source and return true.
     * Why: keep core logic centralized in _transfer for auditability.
     */
    function transfer(address to, uint value) external returns (bool) {
        _transfer(msg.sender, to, value); // move funds
        return true;                      // signal success
    }

    /*
     * Purpose: ERC-20 transferFrom honoring allowances.
     * Line-by-line:
     * - if allowance is not uint(-1) (the sentinel for infinite approval), reduce it by value.
     * - perform transfer from -> to.
     * - return true.
     * Why: supports both finite and infinite approvals; avoids unnecessary storage writes when allowance is max.
     * Example: allowance = 100, value = 30 => new allowance = 70; if allowance = uint(-1) it stays unchanged.
     */
    function transferFrom(address from, address to, uint value) external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value); // consume allowance
        }
        _transfer(from, to, value); // execute transfer
        return true;                // signal success
    }

    /*
     * Purpose: EIP-2612 permit for gasless approvals.
     * Line-by-line:
     * - require deadline not expired (deadline >= block.timestamp).
     * - compute EIP-712 digest = keccak256("\x19\x01" || DOMAIN_SEPARATOR || keccak256(permit struct)).
     *   * permit struct encodes (owner, spender, value, nonce, deadline); nonce is post-incremented to prevent replay.
     * - recover signer via ecrecover and ensure it matches owner and is non-zero.
     * - call _approve to set allowance.
     * Why: allows approvals via signatures so users pay zero gas if relayed; follows EIP-2612.
     * Example digest formula: digest = keccak256(0x1901 || DOMAIN_SEPARATOR || keccak256( PERMIT_TYPEHASH || owner || ... )).
     */
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, 'UniswapV2: EXPIRED'); // signature must still be valid
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',                                  // EIP-191 header
                DOMAIN_SEPARATOR,                            // binds to chain/contract
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline)) // struct hash with current nonce
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s); // recover signer from signature
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE'); // must match owner
        _approve(owner, spender, value);                       // set allowance after successful verification
    }
}
