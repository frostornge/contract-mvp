pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Stake is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    // ERC20 token contract being held
    ERC20 public token;

    constructor(ERC20 _token) public {
        token = _token;
    }

    /**
     * Stake and lock your token.
     * @param amount {uint256} you want to stake
     */
    function deposit(uint256 amount) public {
        require(token.allowance(msg.sender, address(this)) >= amount);
        require(token.balanceOf(msg.sender) >= amount);
        token.safeTransferFrom(msg.sender, address(this), amount);
    }

    /**
     * Withdraw the token you locked up.
     * @param amount {uint256} you want to unstake
     */
    function withdraw(uint256 amount) public {
        require(amount <= stake());
        token.safeTransfer(msg.sender, amount);
    }

    function stake() public view returns (uint256) {
        return token.balanceOf(address(this));
    }
}