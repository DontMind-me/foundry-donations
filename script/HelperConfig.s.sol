//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address pricefeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory EthConfig = NetworkConfig({
            pricefeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return EthConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.pricefeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            pricefeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}
