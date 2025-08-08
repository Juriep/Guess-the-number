// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserContract.sol";

contract UserRegistration {
    
    UserContract private userContract;

    event UserSuccessfullyRegistered(address indexed user, string name, uint256 age);

    constructor(address userContractAddress) {
        userContract = UserContract(userContractAddress);
    }

    function registerUser(string memory name, uint256 age) external {
        userContract.setUser(name, age);
        emit UserSuccessfullyRegistered(msg.sender, name, age);
    }
}