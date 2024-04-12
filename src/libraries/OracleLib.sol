// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title OracleLib
 * @author Kris
 * @notice This library is used to check the chainlink Oracle for stale data.
 * If a price is stale, the function will revert, and render the DSCEngine unstable
 * We want the DSCEngine to freeze if the prices become stale.
 * If chainlink network explodes and you have lot money locked in protocol to bad...
 *
 */
library OracleLib {
    error OracleLib_StalePrice();

    uint256 private constant TIMEOUT = 3 hours; // 3 * 60 * 60 = 10800 seconds

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;

        if (secondsSince > TIMEOUT) revert OracleLib_StalePrice();
        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }
}
