// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title SBFDataTypes
 * @author SBF Hacker Team
 * @notice Library containing SBF contracts custom errors
 *
 */
library SBFDataTypes {

    /// @dev enum to hold bounty status if payed out to hacker or nort
    enum BountyIs{
        UNPAYED,
        PAYED
    }

    /**
     * @notice
     *  Bounty info structure
     *
     * @param bountyIs enum status of bounty
     * @param sponsor address of sponsor
     * @param amount amount to win from specific bounty
     *
     */
    struct Bounty {
        BountyIs bountyIs;
        address sponsor;
        uint256 amount;
    }

    /**
     * @notice 
     *  Zupass proof args
     *
     */
    struct ProofArgs {
        uint256[2] _pA;
        uint256[2][2] _pB;
        uint256[2] _pC;
        uint256[38] _pubSignals;
    }
}