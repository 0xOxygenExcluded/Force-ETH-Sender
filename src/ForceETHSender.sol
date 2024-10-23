// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/access/Ownable.sol";


contract ForceETHSender is Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {}


    receive() external payable {}


    function ForceSend(address payable recipient) external {
        require(address(this).balance > 0, "ForceETHSender -> function ForceSend: No ether to send");

        selfdestruct(recipient);
    }
}