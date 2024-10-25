// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import {Test, console} from "forge-std/Test.sol";
import {ForceETHSender} from "../src/ForceETHSender.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract NonPayableContract {
}


contract ForceETHSenderTest is Test {
    uint256 forkID;
    string MAINNET_URL = vm.envString("MAINNET_URL");

    address owner = makeAddr("owner");
    address payable regularUser = payable (makeAddr("regularUser"));
    ForceETHSender public sender;


    function setUp() public {
        forkID = vm.createFork(MAINNET_URL);
        vm.selectFork(forkID);

        sender = new ForceETHSender(owner);
        vm.deal(owner, 3 ether);
    }


    function test_RecieveEtherBySenderContract() public {
        vm.prank(owner);
        address(sender).call{value: owner.balance}("");

        assertEq(owner.balance, 0 ether);
        assertTrue(address(sender).balance > 0);
    }


    function test_SendEtherToUser() public {
        // send ether to Force Sender Contract
        vm.prank(owner);
        address(sender).call{value: owner.balance}("");
        assertTrue(address(sender).balance > 0);

        vm.prank(owner);
        sender.ForceSend(regularUser);
        assertEq(address(sender).balance, 0 ether);
        assertTrue(regularUser.balance > 0);
    }


    function test_SendEtherToNonPayableContract() public {
        NonPayableContract nonPayableContract = new NonPayableContract();

        // send ether to Force Sender Contract
        vm.prank(owner);
        address(sender).call{value: owner.balance}("");
        assertTrue(address(sender).balance > 0);

        vm.prank(owner);
        sender.ForceSend(payable(address(nonPayableContract)));
        assertEq(address(sender).balance, 0 ether);
        assertTrue(address(nonPayableContract).balance > 0);
    }


    function test_RevertWhenForceSendCallerIsNotContractOwner() public {
        NonPayableContract nonPayableContract = new NonPayableContract();
        // send ether to Force Sender Contract
        vm.deal(regularUser, 1 ether);
        address(sender).call{value: regularUser.balance}("");

        assertTrue(address(sender).balance > 0);


        vm.startPrank(regularUser);
        vm.expectRevert(abi.encodeWithSelector(
                        Ownable.OwnableUnauthorizedAccount.selector,
                        address(regularUser)));

        sender.ForceSend(payable(address(nonPayableContract)));
        vm.stopPrank();
    }
}