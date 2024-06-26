// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/* SBF Libraries */
import {SBFDataTypes} from "src/libraries/SBFDataTypes.sol";

/**
 * @title SBFErrors
 * @author SBF Hacker Team
 * @notice Library containing SBF contracts custom errors
 *
 */
library SBFEvents {
    /// @dev event emitted when a bounty is deposited
    event BountyDeposition(uint256 bountyId, SBFDataTypes.Bounty bountyInfo);

    /// @dev event emitted when a bounty has been payed out
    event BountyPayed(address claimer, SBFDataTypes.Bounty bountyInfo);
}
