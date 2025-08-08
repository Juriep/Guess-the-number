// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserContract {
    
    event UserSuccessfullyStored(address indexed userAddress, string name, uint256 age);
    event UserDeleted(address indexed userAddress);
    event UserUpdated(address indexed userAddress, string name, uint256 age);

    struct User {
        string name;
        uint256 age;
    }

    mapping(address => User) private users;

    modifier onlyNewUser() {
        require(bytes(users[msg.sender].name).length == 0, "User already exists");
        _;
    }

    modifier onlyExistingUser() {
        require(bytes(users[msg.sender].name).length != 0, "User does not exist");
        _;
    }

    /**
     * @notice Retrieves the user information for a given address.
     * @param userAddress The address of the user to retrieve.
     * @return name The name of the user.
     * @return age The age of the user.
     * @return userAddress The address of the user.
     */

    function getUser(address userAddress) external view returns (string memory, uint256, address) {
        User memory user = users[userAddress];
        require(bytes(user.name).length != 0, "User not found");
        return (user.name, user.age, userAddress);
    }

    function setUser(string memory name, uint256 age) external onlyNewUser {
        users[msg.sender] = User(name, age);
        emit UserSuccessfullyStored(msg.sender, name, age);
    }

    function deleteUser() external onlyExistingUser {
        delete users[msg.sender];
        emit UserDeleted(msg.sender);
    }

    function updateUser(string memory name, uint256 age) external onlyExistingUser{
        users[msg.sender].name = name;
        users[msg.sender].age = age;
        emit UserUpdated(msg.sender, name, age);
    }
    
    function isUserRegistered(address userAddress) external view returns (bool) {
        return bytes(users[userAddress].name).length != 0;
    }

}