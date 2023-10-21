// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.9.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // function to get the price of ethereum in usd
    function getPrice() internal view returns (uint256) {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price,,,) = priceFeed.latestRoundData();
        // Price of ETH in USD

        // to get the price of eth to match with usd in terms of number of zeroes, we multiply by 1e10.
        // we also typecast to convert from int to uint256
        return uint256(price * 1e10);
    }

    // function to convert eth to usd
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // the reason for the 1e18 multiplication is because both ethPrice and ethAmount are in 1e18
        // and a result of their multiplication will result in 1e36, which is massive. Hence the need for the division
        return ethAmountInUsd;
    }
}
