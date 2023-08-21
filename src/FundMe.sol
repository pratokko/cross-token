// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;

    address private immutable i_owner;

    address[] private s_funders;
    mapping(address funder => uint256 amount) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "You have not sent enough"
        );
        s_funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];

            addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool success, ) = msg.sender.call{value: address(this).balance}("");

        require(success, "Transfer Failed");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }
}
