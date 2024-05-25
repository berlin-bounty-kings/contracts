// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "lib/forge-std/src/Script.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/* SBF contracts */
import {SafeBountyFund} from "src/SafeBountyFund.sol";

contract DeploySBF is Script {
    using SafeERC20 for IERC20;

    address token = vm.envAddress("TOKEN_ADDRESS");
    address sponsorAddress = vm.envAddress("SPONSOR_ADDRESS");
    uint256 deployerKey = vm.envUint("DEPLOYER_KEY");

    SafeBountyFund sbf;

    IERC20 tokenInstance;

    function run() public {
        vm.startBroadcast(deployerKey);

        sbf = new SafeBountyFund(token);

        sbf.grantRole(0x00, sponsorAddress);
        sbf.grantRole(keccak256("SPONSOR_ROLE"), sponsorAddress);
        sbf.grantRole(keccak256("SPONSOR_ROLE"), vm.addr(deployerKey));

        tokenInstance = IERC20(token);
        tokenInstance.forceApprove(address(sbf), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);

        // Hackers choice
        sbf.depositBounty(
            213102656137810142630059403125621749981,
            7_000e18
        );

        // Defensive Tooling
        sbf.depositBounty(
            213102656137810142630059403125621749982, 
            7_000e18
        );

        // Freedom to transact
        sbf.depositBounty(
            213102656137810142630059403125621749983, 
            7_000e18
        );

        // Social Technologies
        sbf.depositBounty(
            213102656137810142630059403125621749984,
            7_000e18
        );

        // Infrastructure
        sbf.depositBounty(
            213102656137810142630059403125621749985, 
            7_000e18
        );

        // Best Smart Contract
        sbf.depositBounty(
            213102656137810142630059403125621749986, 
            5_000e18
        );

        // Best Social Impact
        sbf.depositBounty(
            212756365423530032915656252450088290525,
            5_000e18
        );

        // Best User Experience
        sbf.depositBounty(
            213102656137810142630059403125621749987,
            5_000e18
        );

        // Meta Award
        sbf.depositBounty(
            213102656137810142630059403125621749988,
            4_000e18
        );

        vm.stopBroadcast();
    }
}
