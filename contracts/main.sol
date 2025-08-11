// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

// contract P2PTransferProject {
//     address public owner;
//     string public name;
//     modifier onlyOwner() {
//         require(msg.sender == owner, "Only owner");
//         _;
//     }

//     constructor(string memory _name) {
//         owner = msg.sender;
//         name = _name;
//     }

//     function getBalance() external view returns (uint256) {
//         return address(this).balance;
//     }

//     function setName(string memory _name) external onlyOwner {
//         name = _name;
//     }

//     function getName() external view returns (string memory) {
//         return name;
//     }

//     function getOwner() external view returns (address) {
//         return owner;
//     }
// }

contract ProjectToken is ERC20 {
    using Strings for uint256;

    constructor() ERC20("ProjectToken", "PTKN") {}

    
}