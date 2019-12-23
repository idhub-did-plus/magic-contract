pragma solidity 0.5.8;

import "../interfaces/ISecurityToken.sol";
import "../interfaces/ITransferManager.sol";
import "../libraries/StatusCodes.sol";

/**
 * @title Transfer Manager for limiting maximum number of token holders
 */
contract CountTransferManager {

    // uint256 public maxHolderCount;
    mapping(address => uint256) maxHolderCounts;

    /** @notice Used to verify the transfer transaction and prevent a transfer if it passes the allowed amount of token holders
     * @param _from Address of the sender
     * @param _to Address of the receiver
     * @param _amount Amount to send
     */
    function transfer(
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata /*_data*/
    )
        external
        returns(ITransferManager.Result result)
    {
        (ITransferManager.Result success, , ) = _verifyTransfer(_from, _to, _amount, ISecurityToken(msg.sender).holderCount());
        return success;
    }

    /**
     * @notice Used to verify the transfer transaction and prevent a transfer if it passes the allowed amount of token holders
     * @dev module.verifyTransfer is called by SecToken.canTransfer and does not receive the updated holderCount therefore
     *      verifyTransfer has to manually account for pot. tokenholder changes (by mimicking TokenLib.adjustInvestorCount).
     *      module.executeTransfer is called by SecToken.transfer|issue|others and receives an updated holderCount 
     *      as sectoken calls TokenLib.adjustInvestorCount before executeTransfer.
     * @param _from Address of the sender
     * @param _to Address of the receiver
     * @param _amount Amount to send
     */
    function canTransfer(
        address _from,
        address _to,
        uint256 _amount,
        bytes memory /* _data */
    )
        public
        view
        returns(ITransferManager.Result result, byte status, bytes32 partition)
    {
        uint256 holderCount = ISecurityToken(msg.sender).holderCount();
        if (_amount != 0 && _from != _to) {
            // Check whether receiver is a new token holder
            if (_to != address(0) && ISecurityToken(msg.sender).balanceOf(_to) == 0) {
                holderCount++;
            }
            // Check whether sender is moving all of their tokens
            if (_amount == ISecurityToken(msg.sender).balanceOf(_from)) {
                holderCount--;
            }
        }

        return _verifyTransfer(_from, _to, _amount, holderCount);
    }

    function _verifyTransfer(
        address _from,
        address _to,
        uint256 _amount,
        uint256 _holderCount
    )
        internal
        view
        returns(ITransferManager.Result result, byte status, bytes32 partition)
    {
        if (maxHolderCounts[msg.sender] < _holderCount) {
            // Allow transfers to existing maxHolders
            if (ISecurityToken(msg.sender).balanceOf(_to) != 0 || ISecurityToken(msg.sender).balanceOf(_from) == _amount) {
                return (ITransferManager.Result.NA, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
            }
            return (ITransferManager.Result.INVALID, StatusCodes.code(StatusCodes.Status.InvalidReceiver), bytes32(uint256(address(this)) << 96));
        }
        return (ITransferManager.Result.NA, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
    }


    /**
     * @notice Used to initialize the variables of the contract
     * @param _maxHolderCount Maximum no. of holders this module allows the SecurityToken to have
     */
    function configure(address _securityToken, uint256 _maxHolderCount) public {
        require(msg.sender == _securityToken || msg.sender == ISecurityToken(_securityToken).owner(), "Invalid Caller");
        maxHolderCounts[_securityToken] = _maxHolderCount;
    }

}
