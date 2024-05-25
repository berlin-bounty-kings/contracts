// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/* Gnosis Safe Interfaces */
import {ISafe} from "@gnosis/contracts/interfaces/ISafe.sol";

/* OpenZeppelin Contracts */
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/* OpenZeppelin Interfaces */
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Safe Bounty Fund
 * @author SBF Hackathon team
 * @notice  Gnosis module for depositing and claiming rewards
 *
 */
contract SBFModule is AccessControl {
    // Using SafeERC20 for safer token transactions
    using SafeERC20 for IERC20;

    //     _____ __        __
    //    / ___// /_____ _/ /____  _____
    //    \__ \/ __/ __ `/ __/ _ \/ ___/
    //   ___/ / /_/ /_/ / /_/  __(__  )
    //  /____/\__/\__,_/\__/\___/____/

    /// @dev Safe instance
    ISafe safe;

    /// @dev Sponsor role
    bytes32 public constant SPONSOR_ROLE = keccak256("SPONSOR_ROLE");

    //      ______     __                        __   ______                 __  _
    //     / ____/  __/ /____  _________  ____ _/ /  / ____/_  ______  _____/ /_(_)___  ____  _____
    //    / __/ | |/_/ __/ _ \/ ___/ __ \/ __ `/ /  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
    //   / /____>  </ /_/  __/ /  / / / / /_/ / /  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  )
    //  /_____/_/|_|\__/\___/_/  /_/ /_/\__,_/_/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/


    function setSafe(address _safeAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
        safe = ISafe(_safeAddress);
    }

    function depositBounty() external onlyRole(SPONSOR_ROLE) {}

    function claimBounty() external {}
}
