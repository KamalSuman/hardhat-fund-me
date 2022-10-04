// SPDX-License-Identifier: MIT
//Pragma
pragma solidity ^0.8.8;
// IMports
import "./PriceConvertor.sol";
// Error Codes
error FundMe__NotOwner();

// Interfaces, Libraries, Contracts

/** @title A contract for crowd funding
 *  @author Kamal Joshi
 *  @notice This contract is to demo a sample funding contract
 *  @dev This implements price feeds as our library
 */
contract FundMe {
    // Type declaration
    using PriceConvertor for uint256;
    // State Variables!
    address[] private s_funders; /// to keep the address of funders who are donating to our contract
    mapping(address => uint256) private s_addressToAmountFunded;
    // Could we make this constant
    uint256 public constant MINIMUM_USD = 50;
    address private immutable i_owner;

    AggregatorV3Interface private s_priceFeed;

    // modifier is basically a piece a code which is basically used to modify function i.e. in this modifier first the require statement will run and check whether it is the real owner or not
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _; // it represents the whole code
    }

    // Functions Order:
    // Constructor
    // receive
    // fallback
    // external
    // public
    // internal
    // private
    // view / pure

    // making constructor to get owner address because it will give you the deployer address when it is deployed.
    constructor(address priceFeedAddress) {
        i_owner = msg.sender; // i.e. your wallet address
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    // receive function
    receive() external payable {
        fund();
    }

    // fallback function
    fallback() external payable {
        fund();
    }

    /**
     * @notice This function funds this contract
     * @dev This implements price feeds as our library
     */
    function fund() public payable {
        // making the function payable  by adding this keyword payable now it can get value of value button in the ide

        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD * 1e18,
            "You need to spend more ETH!"
        ); // if minimumUSD<50 then it will revert the changes i.e. if we have done any computation before require function then revert will undo the change
        s_funders.push(msg.sender); // just like msg.value gives the amount of money msg.sender gives the address of sender
        s_addressToAmountFunded[msg.sender] = msg.value;
    }

    // creating a withdraw function to reset the amount to 0 which is sent by funder

    function withdraw() public onlyOwner {
        // here

        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            s_addressToAmountFunded[s_funders[funderIndex]] = 0;
        }
        // Reseting the funders array
        s_funders = new address[](0); // 0 elements to start with i.e. totally reseting the array
        (bool sendSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(sendSuccess, "Transaction Failed");
    }

    // Pure/ View
    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunders(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    function getAddressToAmountFunded(address funder)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[funder];
    }
}
