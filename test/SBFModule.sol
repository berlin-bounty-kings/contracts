// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SBFModule} from "src/SBFModule.sol";

/* Mock Contracts */
import {MockToken} from "test/mock/MockToken.sol";

contract SBFTest is Test {

    address public deployer;
    address public sponsor;

    SBFModule public sbf;
    MockToken public token;


    function setUp() external {

        deployer = address(0x2);
        sponsor = address(0x3);

        token = new MockToken("token", "MTK");

        token.mint(deployer, 5_000e6);
        token.mint(sponsor, 5_000e6);

        vm.prank(deployer);
        sbf = new SBFModule(address(token));
    }

    function test_depositBounty() external {
        vm.startPrank(sponsor);

        token.approve(address(sbf), 5_000e6);

        sbf.depositBounty("asdfkl", 5_000e6);

        vm.stopPrank();
    }

}
