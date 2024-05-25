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

    /// @dev throw error if hacker tries to claim a non existent bounty
    error BOUNTY_DOES_NOT_EXIST(uint256 bountyId);

    /// @dev throw error if bounty is already payed out
    error BOUNTY_ALREADY_PAYED_OUT();

    /// @dev throw error when proof is invalid
    error INVALID_PROOF();

    /// @dev throw error when signer is i8nvalid
    error INVALID_SIGNER();
}