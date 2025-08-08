// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserContract.sol";

contract UserSignIn {
    
    UserContract private userContract;

    event UserSignedIn(address indexed user);

    constructor(address userContractAddress) {
        userContract = UserContract(userContractAddress);
    }

    function signIn() external {
        require(userContract.isUserRegistered(msg.sender), "User does not exist");
        emit UserSignedIn(msg.sender);
    }

    function isUserSignedIn() external view returns (bool) {
        return userContract.isUserRegistered(msg.sender);
    }

}