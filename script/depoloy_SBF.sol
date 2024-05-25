// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";

/* SBF contracts */
import {SBFModule} from "src/SBFModule.sol";

/* Gnosis Safe Interfaces */
import {ISafe} from "@gnosis/contracts/interfaces/ISafe.sol";

contract DeploySBF is Script {
    address token = vm.envAddress("TOKEN_ADDRESS");
    address safeAddress = vm.envAddress("SAFE_ADDRESS");
    uint256 deployerKey = vm.envUint("DEPLOYER_KEY");


    ISafe safe = ISafe(safeAddress);

    SBFModule sbfModule;

    function run() public {
        vm.startBroadcast(deployerKey);

        sbfModule = new SBFModule(token);

        safe.enableModule(address(sbfModule));

        vm.stopBroadcast();
    }
}
