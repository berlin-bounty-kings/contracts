// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title SBFErrors
 * @author SBF Hacker Team
 * @notice Library containing SBF contracts custom errors
 *
 */
library SBFErrors {
    /// @dev throw error if gnosis safe address is not a contract
    error ADDRESS_NOT_CONTRACT();

    /// @dev throw error if bounty already exists
    error BOUNTY_ALREADY_EXISTS();
}