// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FundMe {
    uint256 public constant MINIMUM_USD = 5e18;

    address[] private s_funders;
    mapping(address funder => uint256 amount) public addressToAmountFunded;

    function fund() public payable {
        require(msg.value >= MINIMUM_USD, "You have not sent enough");
        s_funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
}
