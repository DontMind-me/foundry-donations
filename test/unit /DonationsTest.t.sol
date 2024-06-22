//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Donations} from "../../src/Donations.sol";
import {DeployDonations} from "../../script/DeployDonations.s.sol";

// Types of Tests: Unit, Integration, Forked, Staging
// Steps for Writing tests: 1. Arrange 2. Act 3.Assert

contract DonationTest is Test {
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

    function testMinimumUSDisFive() public {
        assertEq(donations.MINIMUM_USD(), 5e18);
    }

    function testOwnerisMsgSender() public {
        assertEq(donations.getOwner(), msg.sender);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        donations.fund();
    }

    function testFundUpdatesDataStructure() public {
        vm.prank(USER); //The next TX will be sent by user
        donations.fund{value: SEND_VALUE}();

        uint256 amountFunded = donations.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testFundUpdatesFundersArray() public funded {
        assertEq(USER, donations.getFunder(0));
    }

    modifier funded() {
        vm.prank(USER);
        donations.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        donations.withdraw();
    }

    function testOwnerCanWithdrawWithSingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = donations.getOwner().balance;
        uint256 startingDonationsBalance = address(donations).balance;
        //Act
        vm.prank(donations.getOwner());
        donations.withdraw();
        //Assert
        uint256 endingOwnerBalance = donations.getOwner().balance;
        uint256 endingDonationsBalance = address(donations).balance;
        assertEq(endingDonationsBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingDonationsBalance
        );
    }

    function testOwnerCanWithdrawWithManyFunders() public funded {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            donations.fund{value: SEND_VALUE}();

            uint256 startingOwnerBalance = donations.getOwner().balance;
            uint256 startingDonationsBalance = address(donations).balance;

            //Act
            vm.prank(donations.getOwner());
            donations.withdraw();

            //Assert
            uint256 endingOwnerBalance = donations.getOwner().balance;
            assertEq(
                endingOwnerBalance,
                startingOwnerBalance + startingDonationsBalance
            );
            assertEq(0, address(donations).balance);
        }
    }
}
