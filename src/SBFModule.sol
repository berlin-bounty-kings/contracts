// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/* Gnosis Safe Interfaces */
import {ISafe} from "@gnosis/contracts/interfaces/ISafe.sol";

/**
 * @title Safe Bounty Fund
 * @author SBF Hackathon team
 * @notice  Gnosis module for depositing and claiming rewards
 *
 */
contract SBFModule {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
