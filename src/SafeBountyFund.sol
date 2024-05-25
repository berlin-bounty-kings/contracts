// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/* OpenZeppelin Contracts */
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/* OpenZeppelin Interfaces */
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/* SBF Libraries */
import {SBFDataTypes} from "src/libraries/SBFDataTypes.sol";
import {SBFErrors} from "src/libraries/SBFErrors.sol";
import {SBFEvents} from "src/libraries/SBFEvents.sol";
import {Groth16Verifier} from "src/libraries/Groth16Verifier.sol";

/**
 * @title Safe Bounty Fund
 * @author SBF Hackathon team
 * @notice  Contract for depositing and claiming rewards and verifying proofs
 *
 */
contract SafeBountyFund is AccessControl, Groth16Verifier {
    // Using SafeERC20 for safer token transactions
    using SafeERC20 for IERC20;

    //     _____ __        __
    //    / ___// /_____ _/ /____  _____
    //    \__ \/ __/ __ `/ __/ _ \/ ___/
    //   ___/ / /_/ /_/ / /_/  __(__  )
    //  /____/\__/\__,_/\__/\___/____/

    /// @dev This is hex to bigint conversion for ETHBerlin signer
    uint256[2] ETHBERLIN_SIGNER = [
        13908133709081944902758389525983124100292637002438232157513257158004852609027,
        7654374482676219729919246464135900991450848628968334062174564799457623790084
    ];

    /// @dev Token instance
    IERC20 token;

    /// @dev id to bounty payout
    mapping(uint256 bountyId => SBFDataTypes.Bounty bounty) public bountyInfoOf;

    /// @dev Sponsor role
    bytes32 public constant SPONSOR_ROLE = keccak256("SPONSOR_ROLE");

    /// MODIFIERS

    modifier verifiedProof(SBFDataTypes.ProofArgs calldata proof) {
        require(
            this.verifyProof(
                proof._pA,
                proof._pB,
                proof._pC,
                proof._pubSignals
            ),
            "Invalid proof"
        );
        _;
    }

    modifier validSigner(uint256[38] memory _pubSignals) {
        uint256[2] memory signer = getSignerFromPublicSignals(_pubSignals);
        require(
            signer[0] == ETHBERLIN_SIGNER[0] &&
                signer[1] == ETHBERLIN_SIGNER[1],
            "Invalid signer"
        );
        _;
    }

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
        if (!_isContract(_tokenAddress))
            revert SBFErrors.ADDRESS_NOT_CONTRACT();

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
     *  Function that allows sponsors to deposit funds into the smart contract
     *
     * @param _bountyId id for specific bounty
     * @param _amount amount to send in
     *
     */
    function depositBounty(
        uint256 _bountyId,
        uint256 _amount
    ) external onlyRole(SPONSOR_ROLE) {
        // Make sure that the bounty does not exist already
        if (bountyInfoOf[_bountyId].amount != 0)
            revert SBFErrors.BOUNTY_ALREADY_EXISTS();

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
        emit SBFEvents.BountyDeposition(_bountyId, bountyInfoOf[_bountyId]);
    }

    /**
     * @notice
     *  function for a winning hackathon participant to claim their reward
     *
     * @param proof the proof that needs to be verified
     *
     */
    function claimBounty(
        SBFDataTypes.ProofArgs calldata proof
    )
        external
        verifiedProof(proof)
        validSigner(proof._pubSignals)
    {
        // derive bounty id
        uint256 bountyId = getValidEventIdFromPublicSignals(proof._pubSignals)[
            0
        ];

        // Make sure that bounty exists
        if (bountyInfoOf[bountyId].amount == 0)
            revert SBFErrors.BOUNTY_DOES_NOT_EXIST();

        // Make sure that the bounty is still unpayed
        if (bountyInfoOf[bountyId].bountyIs == SBFDataTypes.BountyIs.PAYED)
            revert SBFErrors.BOUNTY_ALREADY_PAYED_OUT();

        // Pay out bounty
        token.safeTransfer(msg.sender, bountyInfoOf[bountyId].amount);

        // Emit event that the bounty has been claimed
        emit SBFEvents.BountyPayed(msg.sender, bountyInfoOf[bountyId]);

        // Set the bountyIs status to PAYED
        bountyInfoOf[bountyId].bountyIs = SBFDataTypes.BountyIs.PAYED;
    }

    //     ____                     ______                 __  _
    //    / __ \__  __________     / ____/_  ______  _____/ /_(_)___  ____  _____
    //   / /_/ / / / / ___/ _ \   / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
    //  / ____/ /_/ / /  /  __/  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  )
    // /_/    \__,_/_/   \___/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/

    // Numbers of events is arbitary but for this example we are using 10 (including test eventID)
    function getValidEventIdFromPublicSignals(
        uint256[38] memory _pubSignals
    ) public pure returns (uint256[] memory) {
        // Events are stored from starting index 15 to till valid event ids length
        uint256[] memory eventIds = new uint256[](1);
        for (uint256 i = 0; i < 1; i++) {
            eventIds[i] = _pubSignals[15 + i];
        }
        return eventIds;
    }

    function getSignerFromPublicSignals(
        uint256[38] memory _pubSignals
    ) external pure returns (uint256[2] memory) {
        uint256[2] memory signer;
        signer[0] = _pubSignals[13];
        signer[1] = _pubSignals[14];
        return signer;
    }

    //     ____      __                        __   ______                 __  _
    //    /  _/___  / /____  _________  ____ _/ /  / ____/_  ______  _____/ /_(_)___  ____  _____
    //    / // __ \/ __/ _ \/ ___/ __ \/ __ `/ /  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
    //  _/ // / / / /_/  __/ /  / / / / /_/ / /  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  )
    // /___/_/ /_/\__/\___/_/  /_/ /_/\__,_/_/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/

    /**
     * @notice
     *  Allows contract to check if the Token address actually is a contract
     *
     * @param _address address we want to check
     *
     * @return _isAddressContract returns true if token is a contract, otherwise returns false
     *
     */
    function _isContract(
        address _address
    ) internal view returns (bool _isAddressContract) {
        uint256 size;

        assembly {
            size := extcodesize(_address)
        }

        _isAddressContract = size > 0;
    }
}
