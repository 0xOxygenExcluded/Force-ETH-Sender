// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import {Script, console} from "forge-std/Script.sol";
import {ForceETHSenderWithHelper} from "../src/ForceETHSenderWithHelper.sol";


contract ForceETHSenderWithHelperScript is Script {
    ForceETHSenderWithHelper public forceETHSender;

    function setUp() public {}

    function run() public {
        bytes32 fixedSalt = keccak256(abi.encodePacked("singleSalt"));

        vm.startBroadcast();

        forceETHSender = new ForceETHSenderWithHelper{salt: fixedSalt}();
        console.log("Deployed contract address:", address(forceETHSender));

        vm.stopBroadcast();
    }
}
