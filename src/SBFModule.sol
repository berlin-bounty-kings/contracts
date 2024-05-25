// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ISafe} from "@gnosis/contracts/interfaces/ISafe.sol";

contract SBFModule {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
