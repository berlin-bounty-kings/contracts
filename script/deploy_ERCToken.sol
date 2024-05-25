// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "lib/forge-std/src/Script.sol";

/* SBF contracts */
import {MockToken} from "test/mock/MockToken.sol";

contract DeploySBF is Script {

    uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
    MockToken public token;

    function run() public {
        vm.startBroadcast(deployerKey);
        token = new MockToken("dai", "DAI");

        token.mint(vm.addr(deployerKey), 1_000_000_000e18);

        vm.stopBroadcast();
    }

}