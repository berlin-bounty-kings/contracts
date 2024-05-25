// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "lib/forge-std/src/Script.sol";

/* SBF contracts */
import {SafeBountyFund} from "src/SafeBountyFund.sol";

contract DeploySBF is Script {
    address token = vm.envAddress("TOKEN_ADDRESS");
    address sponsorAddress = vm.envAddress("SPONSOR_ADDRESS");
    uint256 deployerKey = vm.envUint("DEPLOYER_KEY");

    SafeBountyFund sbf;

    function run() public {
        vm.startBroadcast(deployerKey);

        sbf = new SafeBountyFund(token);

        sbf.grantRole(0x00, sponsorAddress);
        sbf.grantRole(keccak256("SPONSOR_ROLE"), sponsorAddress);

        vm.stopBroadcast();
    }
}
