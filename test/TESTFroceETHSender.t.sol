// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


import {Test, console} from "forge-std/Test.sol";
import {ForceETHSenderWithHelper, SelfDestructHelper} from "../src/ForceETHSenderWithHelper.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


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

        sender = new ForceETHSenderWithHelper(owner);
        vm.deal(owner, 3 ether);
    }


    function test_SendEtherToUser() public {
        vm.prank(owner);
        sender.forceSend{value: owner.balance}(regularUser);
        assertTrue(regularUser.balance > 0);
    }


    function test_SendEtherToNonPayableContract() public {
        NonPayableContract nonPayableContract = new NonPayableContract();

        vm.prank(owner);
        sender.forceSend{value: owner.balance}(payable(address(nonPayableContract)));
        assertTrue(address(nonPayableContract).balance > 0);
    }


    function test_RevertWhenForceSendCallerIsNotContractOwner() public {
        NonPayableContract nonPayableContract = new NonPayableContract();

        vm.startPrank(regularUser);
        vm.expectRevert(abi.encodeWithSelector(
                        Ownable.OwnableUnauthorizedAccount.selector,
                        address(regularUser)));

        sender.forceSend{value: regularUser.balance}(payable(address(nonPayableContract)));
        vm.stopPrank();
    }
}