// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/* Gnosis Safe Interfaces */
import {ISafe} from "@gnosis/contracts/interfaces/ISafe.sol";

/* OpenZeppelin Contracts */
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/* OpenZeppelin Interfaces */
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/* SBF Libraries */
import {SBFDataTypes} from "src/libraries/SBFDataTypes.sol";
import {SBFErrors} from "src/libraries/SBFErrors.sol";
import {SBFEvents} from "src/libraries/SBFEvents.sol";

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

    /// @dev Token instance
    IERC20 token;

    /// @dev id to bounty payout
    mapping(string bountyId => SBFDataTypes.Bounty bounty) public bountyInfoOf;

    /// @dev Sponsor role
    bytes32 public constant SPONSOR_ROLE = keccak256("SPONSOR_ROLE");

    //    ______                 __                  __
    //   / ____/___  ____  _____/ /________  _______/ /_____  _____
    //  / /   / __ \/ __ \/ ___/ __/ ___/ / / / ___/ __/ __ \/ ___/
    // / /___/ /_/ / / / (__  ) /_/ /  / /_/ / /__/ /_/ /_/ / /
    // \____/\____/_/ /_/____/\__/_/   \__,_/\___/\__/\____/_/

    /**
     * @notice 
     *  Constructor for SBF safe module
     *
     * @param _tokenAddress address of token used for bounty payouts
     *
     */
    constructor(address _tokenAddress) {
        // Make sure that token address is valid
        if (!_isContract(_tokenAddress)) revert SBFErrors.ADDRESS_NOT_CONTRACT();

        // create instance
        token = IERC20(_tokenAddress);

        // Grant deployer default admin role
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

    }

    //      ______     __                        __   ______                 __  _
    //     / ____/  __/ /____  _________  ____ _/ /  / ____/_  ______  _____/ /_(_)___  ____  _____
    //    / __/ | |/_/ __/ _ \/ ___/ __ \/ __ `/ /  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
    //   / /____>  </ /_/  __/ /  / / / / /_/ / /  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  )
    //  /_____/_/|_|\__/\___/_/  /_/ /_/\__,_/_/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/

    /**
     * @notice
     *  Setter function to set the address of the safe
     *  Only callabele by the default admin
     *
     * @param _safeAddress address of safe
     *
     */
    function setSafe(address _safeAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
        // Make sure that safe address is contract
        if (!_isContract(_safeAddress)) revert SBFErrors.ADDRESS_NOT_CONTRACT();

        // Create safe instance
        safe = ISafe(_safeAddress);
    }


    /**
     * @notice 
     *  Function that allows sponsors to deposit funds into the smart contract
     *
     * @param _bountyId id for specific bounty
     * @param _amount amount to send in
     *
     */
    function depositBounty(string memory _bountyId, uint256 _amount) external onlyRole(SPONSOR_ROLE) {
        // Make sure that the bounty does not exist already
        if (bountyInfoOf[_bountyId].amount != 0) revert SBFErrors.BOUNTY_ALREADY_EXISTS();

        // Fetch balance before 
        uint256 balanceBefore = token.balanceOf(address(this));

        // Do the transaction into the safe
        token.safeTransferFrom(msg.sender, address(this), _amount);

        // Fetch balance after
        uint256 balanceAfter = token.balanceOf(address(this));

        // Calculate the realized amount recieved
        uint256 realizedAmount = balanceAfter - balanceBefore;

        // create the bounty entry
        bountyInfoOf[_bountyId] = SBFDataTypes.Bounty(
            SBFDataTypes.BountyIs.UNPAYED,
            msg.sender,
            realizedAmount
        );

        // Emit an event that the bounty has been deposited
        emit SBFEvents.BountyDeposition(
            _bountyId,
            bountyInfoOf[_bountyId]
        );
    }

    /**
     * @notice
     *  function for a winning hackathon participant to claim their reward
     *
     * @param _bountyId id of the bounty that the hacker won
     *
     */
    function claimBounty(string memory _bountyId) external {
        // Make sure that bounty exists
        if (bountyInfoOf[_bountyId].amount == 0) revert SBFErrors.BOUNTY_DOES_NOT_EXIST();

        // Make sure that the bounty is still unpayed
        if (bountyInfoOf[_bountyId].bountyIs == SBFDataTypes.BountyIs.PAYED) revert SBFErrors.BOUNTY_ALREADY_PAYED_OUT();

        // Pay out bounty
        token.safeTransferFrom(address(this), msg.sender, bountyInfoOf[_bountyId].amount);

        // Emit event that the bounty has been claimed
        emit SBFEvents.BountyPayed(
            msg.sender,
            bountyInfoOf[_bountyId]
        );

        // Set the bountyIs status to PAYED
        bountyInfoOf[_bountyId].bountyIs = SBFDataTypes.BountyIs.PAYED;
    }

    /**
     * @notice
     *  Allows contract to check if the Token address actually is a contract
     *
     * @param _address address we want to check
     *
     * @return _isAddressContract returns true if token is a contract, otherwise returns false
     *
     */
    function _isContract(address _address) internal view returns (bool _isAddressContract) {
        uint256 size;

        assembly {
            size := extcodesize(_address)
        }

        _isAddressContract = size > 0;
    }
}
