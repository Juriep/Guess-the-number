// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HouseContract {
    // Owner of the contract
    address public owner;

    address public betContractAddress;

    uint256 public minBet = 0.01 ether;
    uint256 public maxBet = 100 ether;

    event BetReceived(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);
    event PrizePaid(address indexed to, uint256 prize);

    // Store the last bet amount for each user
    mapping(address => uint256) public userLastBet;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyBetContract() {
        require(msg.sender == betContractAddress, "Caller is not the BetContract");
        _;
    }

    constructor() {
        owner = msg.sender;
    }


    function setBetContract(address _betContractAddress) external onlyOwner {
        betContractAddress = _betContractAddress;
    }

    function placeBetForUser(address user) external payable {
        
        require(msg.value >= minBet && msg.value <= maxBet, "Bet out of range");
        require(msg.sender == betContractAddress, "Not authorized");
        userLastBet[user] = msg.value;
        emit BetReceived(user, msg.value);

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

    function handleLoss(address user) external onlyBetContract {
        require(userLastBet[user] > 0, "No bet found for this user");
        userLastBet[user] = 0;
    }

    // Get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}