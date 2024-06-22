//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Donations} from "../../src/Donations.sol";
import {DeployDonations} from "../../script/DeployDonations.s.sol";
import {FundDonations, WithdrawDonations} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    Donations donations;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; //100000000000000000
    uint256 constant BALANCE = 10 ether; //Starting balance for "USER"

    function setUp() external {
        //donations = new Donations(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployDonations deployDonations = new DeployDonations();
        donations = deployDonations.run();
        vm.deal(USER, BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundDonations fundDonations = new FundDonations();
        fundDonations.fundDonations(address(donations));

        assertEq(msg.sender, donations.getFunder(0));
    }

    function testUserCanWithdrawInteractions() public {
        WithdrawDonations withdrawDonations = new WithdrawDonations();
        withdrawDonations.withdrawDonations(address(donations));

        assert(address(donations).balance == 0);
    }
}
