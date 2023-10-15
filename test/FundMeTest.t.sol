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
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
}