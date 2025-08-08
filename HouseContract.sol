// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HouseContract {
    // Owner of the contract
    address public owner;

    uint256 public minBet = 0.01 ether;
    uint256 public maxBet = 10 ether;

    event BetReceived(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);
    event PrizePaid(address indexed to, uint256 prize);

    // Store the last bet amount for each user
    mapping(address => uint256) public userLastBet;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Allow users to place bets by sending ETH
    // This function can be called by anyone to place a bet
    receive() external payable {
        require(msg.value >= minBet && msg.value <= maxBet, "Bet out of range");
        userLastBet[msg.sender] = msg.value;
        emit BetReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        require(msg.value >= minBet && msg.value <= maxBet, "Bet out of range");
        userLastBet[msg.sender] = msg.value;
        emit BetReceived(msg.sender, msg.value);
    }

    // Allow the owner to withdraw ETH from the contract
    function withdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner).transfer(amount);
        emit Withdrawal(owner, amount);
    }

    // Pay prize to the winner (3x the bet)
    function payPrize(address winner) external onlyOwner {
        uint256 betAmount = userLastBet[winner];
        require(betAmount > 0, "No bet found for user");
        uint256 prize = betAmount * 3;
        require(address(this).balance >= prize, "Insufficient balance for prize");
        payable(winner).transfer(prize);
        emit PrizePaid(winner, prize);
        userLastBet[winner] = 0; // Reset after paying prize
    }

    // Get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}