/**
 * DISCLAIMER: Under certain conditions, the limit could be bypassed if a large token holder
 * redeems a huge portion of their tokens. It will cause the total supply to drop
 * which can result in some other token holders having a percentage of tokens
 * higher than the intended limit.
 */

pragma solidity 0.5.8;

import "../interfaces/ISecurityToken.sol";
import "../interfaces/ITransferManager.sol";
import "../libraries/StatusCodes.sol";
import "../libraries/SafeMath.sol";

/**
 * @title Transfer Manager module for limiting percentage of token supply a single address can hold
 */
contract PercentageTransferManager {
    using SafeMath for uint256;

    // Maximum percentage that any holder can have, multiplied by 10**16 - e.g. 20% is 20 * 10**16
    mapping(address => uint256) public maxHolderPercentages;
    
    function transfer(
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata /* _data */
    )
        external
        returns(ITransferManager.Result)
    {
        (ITransferManager.Result success, , ) = _verifyTransfer(_from, _to, _amount);
        return success;
    }

    /**
     * @notice Used to verify the transfer transaction and prevent a given account to end up with more tokens than allowed
     * @param _from Address of the sender
     * @param _to Address of the receiver
     * @param _amount The amount of tokens to transfer
     */
    function canTransfer(
        address _from,
        address _to,
        uint256 _amount,
        bytes memory /*_data*/
    )
        public
        view
        returns(ITransferManager.Result result, byte status, bytes32 partition)
    {
        return _verifyTransfer(_from, _to, _amount);
    }

    function _verifyTransfer(
        address _from,
        address _to,
        uint256 _amount
    )
        internal
        view
        returns(ITransferManager.Result result, byte status, bytes32 partition)
    {
        /*if (_from == address(0) && allowPrimaryIssuance) {
            return (Result.NA, bytes32(0));
        }
        // If an address is on the whitelist, it is allowed to hold more than maxHolderPercentage of the tokens.
        if (whitelist[_to]) {
            return (Result.NA, bytes32(0));
        }*/
        uint256 newBalance = ISecurityToken(msg.sender).balanceOf(_to).add(_amount);
        if (newBalance.div(ISecurityToken(msg.sender).totalSupply()) > maxHolderPercentages[msg.sender]) {
            return (ITransferManager.Result.INVALID, StatusCodes.code(StatusCodes.Status.InvalidReceiver), bytes32(uint256(address(this)) << 96));
        }
        return (ITransferManager.Result.NA, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
    }

    /**
     * @notice Used to intialize the variables of the contract
     * @param _maxHolderPercentage Maximum amount of ST20 tokens(in %) can hold by the investor
     */
    function configure(address _securityToken, uint256 _maxHolderPercentage) public {
        require(msg.sender == _securityToken || msg.sender == ISecurityToken(_securityToken).owner(), "Invalid Caller");
        maxHolderPercentages[_securityToken] = _maxHolderPercentage;
        // allowPrimaryIssuance = _allowPrimaryIssuance;
    }

}
