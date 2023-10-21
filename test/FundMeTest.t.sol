// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.0 < 0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        console.log(fundMe.MINIMUM_USD());
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        // assertEq(fundMe.i_owner(), msg.sender);
        // This test will fail because FundMeTest is the contract that deployed the fundMe address
        // in the setUp(); function, hence it will be the owner
        // While in this particular function, msg.sender is whoever is calling the FundMeTest
        // i.e., Us ->(calls) FundMeTest ->(deploys) fundMe
        // msg.sender = us
        // fundMe.i_owner = FundMeTest
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
