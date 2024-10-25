// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


contract ForceETHSenderWithHelper{
    
    constructor() {}


    function forceSend(address payable receiver) external payable {
        (new SelfDestructHelper){value: msg.value}(receiver);
    }


    receive() external payable {}
}


contract SelfDestructHelper {

    constructor(address payable receiver) payable {
        selfdestruct(receiver);
    }
}