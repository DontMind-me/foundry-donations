// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {Donations} from "../src/Donations.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundDonations is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundDonations(address mostRecentContract) public {
        vm.startBroadcast();
        Donations(payable(mostRecentContract)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentContract = DevOpsTools.get_most_recent_deployment(
            "Donations",
            block.chainid
        );

        fundDonations(mostRecentContract);
    }
}

contract WithdrawDonations is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function withdrawDonations(address mostRecentContract) public {
        vm.startBroadcast();
        Donations(payable(mostRecentContract)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentContract = DevOpsTools.get_most_recent_deployment(
            "Donations",
            block.chainid
        );

        withdrawDonations(mostRecentContract);
    }
}
