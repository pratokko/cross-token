// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address public USER = makeAddr("user");

    uint256 public constant STARTING_BAL = 10 ether;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();

        fundMe = deployer.run();

        vm.deal(USER, STARTING_BAL);
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
}
