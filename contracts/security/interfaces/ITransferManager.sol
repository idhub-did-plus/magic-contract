pragma solidity 0.5.8;

/**
 * @title Interface to be implemented by all Transfer Manager modules
 */
interface ITransferManager {
    //  If verifyTransfer returns:
    //  FORCE_VALID, the transaction will always be valid, regardless of other TM results
    //  INVALID, then the transfer should not be allowed regardless of other TM results
    //  VALID, then the transfer is valid for this TM
    //  NA, then the result from this TM is ignored
    enum Result {INVALID, NA, VALID, FORCE_VALID}

    /**
     * @notice Determines if the transfer between these two accounts can happen
     */
    function transfer(address _partition, address _from, address _to, uint256 _amount, bytes calldata _data) external returns(Result result);

    function canTransfer(address _partition, address _from, address _to, uint256 _amount, bytes calldata _data) external view returns(Result result, byte status, bytes32 partition);

    /**
     * @notice return the amount of tokens for a given user as per the partition
     * @param _partition Identifier
     * @param _tokenHolder Whom token amount need to query
     * @param _additionalBalance It is the `_value` that transfer during transfer/transferFrom function call
     */
    // function getTokensByPartition(bytes32 _partition, address _tokenHolder, uint256 _additionalBalance) external view returns(uint256 amount);

}
