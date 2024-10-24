// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/access/Ownable.sol";
import {console} from "forge-std/Test.sol";


contract ForceETHSenderWithHelper is Ownable {
    
    constructor(address initialOwner) Ownable(initialOwner) {}


    function forceSend(address payable recipient) external payable onlyOwner {
        SelfDestructHelper helper = new SelfDestructHelper();
        helper.destruct{value: msg.value}(recipient);
    }


    receive() external payable {}
}


contract SelfDestructHelper {

    constructor() {}

    function destruct(address payable recipient) payable public {
        require(address(this).balance > 0, "TESTForceETHSender -> SelfDestructHelper -> function destruct: No ether to send");
        selfdestruct(recipient);
    }
}