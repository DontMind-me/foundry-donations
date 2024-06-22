//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Donations} from "../src/Donations.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployDonations is Script {
    function run() external returns (Donations) {

        HelperConfig helperConfig = new HelperConfig();
        address ETHUSDpricefeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        Donations donations = new Donations(ETHUSDpricefeed);
        vm.stopBroadcast();
        return donations;
    }
}
