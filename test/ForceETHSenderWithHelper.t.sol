// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import {Test, console} from "forge-std/Test.sol";
import {ForceETHSenderWithHelper, SelfDestructHelper} from "../src/ForceETHSenderWithHelper.sol";


contract NonPayableContract {
}


contract ForceETHSenderWithHelperTest is Test {
    uint256 forkID;
    string MAINNET_URL = vm.envString("MAINNET_URL");

    address owner = makeAddr("owner");
    address payable regularUser = payable (makeAddr("regularUser"));
    ForceETHSenderWithHelper public sender;


    function setUp() public {
        forkID = vm.createFork(MAINNET_URL);
        vm.selectFork(forkID);

        sender = new ForceETHSenderWithHelper();
        vm.deal(owner, 3 ether);
    }


    function test_SendEtherToUser() public {
        uint256 initialOwnerBalance = owner.balance;

        vm.prank(owner);
        sender.forceSend{value: owner.balance}(regularUser);
        assertEq(regularUser.balance, initialOwnerBalance);
    }


    function test_SendEtherToNonPayableContract() public {
        NonPayableContract nonPayableContract = new NonPayableContract();
        uint256 initialOwnerBalance = owner.balance;

        vm.prank(owner);
        sender.forceSend{value: owner.balance}(payable(address(nonPayableContract)));
        assertEq(initialOwnerBalance, address(nonPayableContract).balance);
    }
}