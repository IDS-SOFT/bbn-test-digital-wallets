// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DigitalWallet {
    address public owner;
    mapping(address => uint256) public tokenBalances;

    event TokensDeposited(address indexed token, address indexed sender, uint256 amount);
    event TokensTransferred(address indexed token, address indexed recipient, uint256 amount);
    event CheckBalance(string text, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function depositTokens(address _tokenAddress, uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        
        IERC20 token = IERC20(_tokenAddress);
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        tokenBalances[_tokenAddress] += _amount;

        emit TokensDeposited(_tokenAddress, msg.sender, _amount);
    }

    function transferTokens(address _tokenAddress, address _recipient, uint256 _amount) external {
        require(_tokenAddress != address(0), "Invalid address");
        require(_recipient != address(0), "Invalid recipient address");
        require(_amount > 0, "Amount must be greater than 0");
        require(tokenBalances[_tokenAddress] >= _amount, "Insufficient balance");

        IERC20 token = IERC20(_tokenAddress);
        tokenBalances[_tokenAddress] -= _amount;

        require(token.transfer(_recipient, _amount), "Transfer failed");

        emit TokensTransferred(_tokenAddress, _recipient, _amount);
    }

    function getTokenBalance(address _tokenAddress) external view returns (uint256) {
        require(_tokenAddress != address(0), "Invalid address");

        return tokenBalances[_tokenAddress];
    }

    function withdrawTokens(address _tokenAddress, uint256 _amount) external onlyOwner {
        require(_tokenAddress != address(0), "Invalid address");
        require(tokenBalances[_tokenAddress] >= _amount, "Insufficient balance");

        IERC20 token = IERC20(_tokenAddress);
        tokenBalances[_tokenAddress] -= _amount;

        require(token.transfer(owner, _amount), "Transfer failed");
    }
    
    function getBalance(address user_account) external returns (uint){
        require(user_account != address(0), "Invalid address");

        uint user_bal = user_account.balance;
        emit CheckBalance(user_bal);
        return (user_bal);
    }
}
