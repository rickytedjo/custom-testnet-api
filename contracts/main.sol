// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract P2PTransferProject {
    address public owner;
    string public name;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(string memory _name) {
        owner = msg.sender;
        name = _name;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function setName(string memory _name) external onlyOwner {
        name = _name;
    }

    function getName() external view returns (string memory) {
        return name;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}