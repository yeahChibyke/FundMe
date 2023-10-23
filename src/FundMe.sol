// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.9.0;

// PriceConverter is a library for all uint256 in FundMe

import {PriceConverter} from "./PriceConverter.sol";

// added this import because of the getVersion() function I added newly
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    // funders is an array of the people who send money
    address[] public funders;

    // lets make a mapping to know how much each funder sent, and you can even name these types in the mapping
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    // address for owner of the contract
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Send enough ETH!");
        // to keep track of funders, we use the global variable; msg.sender which keeps track of whoever called the fund function
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "Must be owner!");
        // the above modifies the withdraw so that only the owner can make withdrawals,
        // but it is replaced by the use of a modifier

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            // to access the zero width of the funders address
            address funder = funders[funderIndex];
            // then use the funder to reset the mapping addressToAmountFunded
            addressToAmountFunded[funder] = 0;
            // this is basically resetting whatever we added when they funded us down to zero
            // because we are withdrawing all the money out
        }
        // reset the array
        // use of the 'new' keyword to reset the funders array to a brand new blank address array
        // this sorts of gives us the balance
        funders = new address[](0);

        // withdraw the funds
        // there are three ways to go about this:

        // 1. transfer
        // to transfer the funds to whoever is calling the withdraw function
        /* payable(msg.sender).transfer(address(this).balance); */
        // payable typecasts msg.sender from address to payable address.
        // In solidity, in order to send native blockchain token like ETH,
        // you can only work withpayable addresses
        // The 'this' keyword refers to the whole contract
        // The problem with 'transfer' is that it is capped at 2300 gas,
        // so if more gas is used, it throws an error

        // 2. send
        /* bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed!"); */
        // 'send' is capped at 2300 gas, so if more gas is used,
        // the transfer reverts and returns that bool message
        // If the bool is not specified and the gas cap is exceeded,
        // the contract will not revert the transaction, and we wont get our money sent

        // 3. call - n.b. call is very confusing atm. Will return to it later
        (bool callSucess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucess, "Call failed!");
    }

    // added this function so I can practice writing tests
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    // added this function to test casting
    function getMinUsd() public pure returns(uint256) {
      return MINIMUM_USD;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;

        // The order of the underscore matters
        // If it comes before the modifier, it means wherever the modifer is placed
        // the code in thet function should run before the modifer runs.
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
