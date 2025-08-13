// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserContract.sol";
import "./UserSignIn.sol";
import "./HouseContract.sol";

contract BetContract {
    UserContract private userContract;
    UserSignIn private userSignIn;
    HouseContract private houseContract;

    event Win(address indexed user, uint256 amount);
    event Loss(address indexed user, uint256 amount);

    constructor(address _userContract, address _userSignIn, address _houseContract) {
        userContract = UserContract(_userContract);
        userSignIn = UserSignIn(_userSignIn);
        houseContract = HouseContract(_houseContract);
    }

    function randomNumber() private view returns (uint8) {
        return uint8((uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 3) + 1);
    }

    function bet(uint8 chosenNumber) external payable {
        require(msg.value > 0, "Bet amount must be greater than 0");
        require(chosenNumber >= 1 && chosenNumber <= 3, "Choose a number between 1 and 3");


        (string memory name,,) = userContract.getUser(msg.sender);
        require(bytes(name).length != 0, "User not registered");

        userSignIn.signIn();

        houseContract.placeBetForUser{value: msg.value}(msg.sender);

        uint8 rand = randomNumber();
        bool won = (chosenNumber == rand);

        if (won) {
            houseContract.payPrize(msg.sender);
            emit Win(msg.sender, msg.value * 3);
        }
        else {
            houseContract.handleLoss(msg.sender);
            emit Loss(msg.sender, msg.value);
        }        
    }
}