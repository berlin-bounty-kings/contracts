// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SBFModule} from "src/SBFModule.sol";

/* Mock Contracts */
import {MockToken} from "test/mock/MockToken.sol";

contract SBFTest is Test {
    address public deployer;
    address public sponsor;
    address public winningHacker;

    SBFModule public sbf;
    MockToken public token;

    function setUp() external {
        deployer = address(0x2);
        sponsor = address(0x3);
        winningHacker = address(0x4);

        token = new MockToken("token", "MTK");

        token.mint(deployer, 5_000e6);
        token.mint(sponsor, 5_000e6);

        vm.startPrank(deployer);
        sbf = new SBFModule(address(token));

        sbf.grantRole(keccak256("SPONSOR_ROLE"), sponsor);

        vm.stopPrank();
    }

    function test_depositBounty() external {
        vm.startPrank(sponsor);

        token.approve(address(sbf), 5_000e6);

        sbf.depositBounty(23492, 5_000e6);

        vm.stopPrank();
    }

    // function test_claimBounty() external {
        // vm.startPrank(sponsor);

        // token.approve(address(sbf), 5_000e6);

        // sbf.depositBounty(23492, 5_000e6);

        // vm.stopPrank();

        // vm.startPrank(winningHacker);

        // // sbf.claimBounty();

        // // vm.stopPrank();
    // }
}
