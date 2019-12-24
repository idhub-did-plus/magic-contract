pragma solidity 0.5.8;

import "../interfaces/ISecurityToken.sol";
import "../interfaces/ITransferManager.sol";
import "../libraries/StatusCodes.sol";
// import "openzeppelin-solidity/contracts/math/Math.sol";

contract LockUpTransferManager {
    using SafeMath for uint256;

    mapping(address => mapping(address => LockUp[])) public lockupsByUsers;

    // a per-user lockup
    struct LockUp {
        uint256 lockupAmount; // Amount to be locked
        uint256 startTime; // when this lockup starts (seconds)
        uint256 lockUpPeriodSeconds; // total period of lockup (seconds)
        uint256 releaseFrequencySeconds; // how often to release a tranche of tokens (seconds)
    }

    mapping (address => LockUp[]) public lockupsByTokens;

    /** @notice Used to verify the transfer transaction and prevent locked up tokens from being transferred
     * @param _from Address of the sender
     * @param _amount The amount of tokens to transfer
     */
    function transfer(address  _from, address /*_to*/, uint256  _amount, bytes calldata /*_data*/) external returns(ITransferManager.Result) {
        (ITransferManager.Result success, , ) = _verifyTransfer(_from, _amount);
        return success;
    }

    /** @notice Used to verify the transfer transaction and prevent locked up tokens from being transferred
     * @param _from Address of the sender
     * @param _amount The amount of tokens to transfer
     */
    function canTransfer(
        address  _from,
        address /* _to*/,
        uint256  _amount,
        bytes memory /* _data */
    )
        public
        view
        returns(ITransferManager.Result result, byte status, bytes32 partition)
    {
        return _verifyTransfer(_from, _amount);
    }

    /** @notice Used to verify the transfer transaction and prevent locked up tokens from being transferred
     * @param _from Address of the sender
     * @param _amount The amount of tokens to transfer
     */
    function _verifyTransfer(
        address  _from,
        uint256  _amount
    )
        internal
        view
        returns(ITransferManager.Result result, byte status, bytes32 partition)
    {
        // only attempt to verify the transfer if the token is unpaused, this isn't a mint txn, and there exists a lockup for this user
        if (lockupsByTokens[msg.sender].length != 0 || lockupsByUsers[msg.sender][_from].length != 0) {
            // check if this transfer is valid
            return _checkIfValidTransfer(_from, _amount);
        }
        return (ITransferManager.Result.NA, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
    }

    /**
     * @notice Checks whether the transfer is allowed
     * @param _userAddress Address of the user whose lock ups should be checked
     * @param _amount Amount of tokens that need to transact
     */
    function _checkIfValidTransfer(address _userAddress, uint256 _amount) internal view returns (ITransferManager.Result, byte status, bytes32) {
        uint256 totalRemainingLockedAmount = getLockedTokenToUser(_userAddress);
        // Present balance of the user
        uint256 currentBalance = ISecurityToken(msg.sender).balanceOf(_userAddress);
        if ((currentBalance.sub(_amount)) >= totalRemainingLockedAmount) {
            return (ITransferManager.Result.NA, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
        }
        return (ITransferManager.Result.INVALID, StatusCodes.code(StatusCodes.Status.FundsLocked), bytes32(uint256(address(this)) << 96));
    }

    /**
     * @notice Use to get the total locked tokens for a given user
     * @param _userAddress Address of the user
     * @return uint256 Total locked tokens amount
     */
    function getLockedTokenToUser(address _userAddress) public view returns(uint256) {
        _checkZeroAddress(_userAddress);
        uint256 totalRemainingLockedAmount = 0;
        for (uint256 i = 0; i < lockupsByUsers[msg.sender][_userAddress].length; i++) {
            if (lockupsByUsers[msg.sender][_userAddress][i].startTime.add(lockupsByUsers[msg.sender][_userAddress][i].lockUpPeriodSeconds) > now) {
                totalRemainingLockedAmount = totalRemainingLockedAmount.add(lockupsByUsers[msg.sender][_userAddress][i].lockupAmount);
            }
        }

        for (uint256 i = 0; i < lockupsByTokens[msg.sender].length; i++) {
            if (lockupsByTokens[msg.sender][i].startTime.add(lockupsByTokens[msg.sender][i].lockUpPeriodSeconds) > now) {
                totalRemainingLockedAmount = totalRemainingLockedAmount.add(lockupsByTokens[msg.sender][i].lockupAmount);
            }
        }
        return totalRemainingLockedAmount;
    }

    function addLockUpToUser(
        address _tokenAddress, 
        address _user, 
        uint256 _lockupAmount,
        uint256 _startTime,
        uint256 _lockUpPeriodSeconds,
        uint256 _releaseFrequencySeconds
    )
        external
    {
        require(msg.sender == _tokenAddress || msg.sender == ISecurityToken(_tokenAddress).owner(), "Invalid Caller");
        LockUp memory lockup = LockUp(_lockupAmount, _startTime, _lockUpPeriodSeconds, _releaseFrequencySeconds);
        lockupsByUsers[_tokenAddress][_user].push(lockup);
    }

    function addLockUpToAllUsers(
        address _tokenAddress, 
        uint256 _lockupAmount,
        uint256 _startTime,
        uint256 _lockUpPeriodSeconds,
        uint256 _releaseFrequencySeconds
    )
        external
    {
        require(msg.sender == _tokenAddress || msg.sender == ISecurityToken(_tokenAddress).owner(), "Invalid Caller");
        LockUp memory lockup = LockUp(_lockupAmount, _startTime, _lockUpPeriodSeconds, _releaseFrequencySeconds);
        lockupsByTokens[_tokenAddress].push(lockup);
    }

    function _checkValidStartTime(uint256 _startTime) internal view {
        require(_startTime >= now, "Invalid startTime or expired");
    }

    function _checkZeroAddress(address _userAddress) internal pure {
        require(_userAddress != address(0), "Invalid address");
    }
}
