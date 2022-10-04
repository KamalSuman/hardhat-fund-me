// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
    function getPrice(AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        // Address of the contract ---> It can be found in the chain-link doc in the data feed section of current addresses
        // Address ----> 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        // ABI (Application Binary Interface) ---> When you need to use the Code of another contract to use some of it's functions then you copy the interface of that contract into your contract to fetch those functionalities
        // For that interface either you can copy the whole Interface or can just import it using the import keyword along with the path
        //this is the most easy way to interact with contract that are outside i.e. we use the ABI with address to get the whole contract.
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10); // 1316059946540000000000 it will return this much value so conversion will be ans/1e18;
    }

    // function getVersion() internal view returns (uint256) {
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //         0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
    //     ); //this is the most easy way to interact with contract that are outside i.e. we use the ABI with address to get the whole contract.
    //     return priceFeed.version();
    // }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
