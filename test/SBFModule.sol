// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SBFModule} from "src/SBFModule.sol";

contract SBFTest is Test {

    address token;
    address deployer;
    address sponsor;

    function setUp() external {
        token = address(0x01);
    }

}
