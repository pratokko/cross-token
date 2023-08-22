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

    function withdraw() public {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            s_funders++
        ) {
            address funder = s_funders[funderIndex];

            addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool success, ) = msg.sender.call{value: address(this).balance}("");

        require(success, "Transfer Failed");
    }
}
