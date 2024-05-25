// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SBFModule} from "src/SBFModule.sol";

contract DeploySBF is Script {
    address token = vm.envAddress("TOKEN_ADDRESS");
    uint256 deployerKey = vm.envUint("DEPLOYER_KEY");

    SBFModule sbfModule;

    function run() public {
        vm.startBroadcast(deployerKey);

        sbfModule = new SBFModule(token);

        vm.stopBroadcast();
    }
}
