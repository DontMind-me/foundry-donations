// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        AggregatorV3Interface priceFeedContract = AggregatorV3Interface(
            pricefeed
        );
        (, int256 answer, , , ) = priceFeedContract.latestRoundData();
        return uint256(answer);
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(pricefeed);
        uint256 ethInUSD = (ethPrice * ethAmount) * 1000000000000000000;
        return ethInUSD;
    }
}
