pragma solidity 0.5.8;

import "../interfaces/ITransferManager.sol";
import "../libraries/StatusCodes.sol";

contract Pause {
    mapping(address => bool) private pausable;

    function isPausable() external view returns(bool) {
        return pausable[msg.sender];
    }

    function setPausable(bool _pausable) external {
        pausable[msg.sender] = _pausable;
    }

    function _isPausable() internal view returns(bool) {
        return pausable[msg.sender];
    }

    function transfer(address _from, address _to, uint256 _amount, bytes calldata _data) external returns(ITransferManager.Result result) {
        if (_isPausable()) return ITransferManager.Result.INVALID;
        return ITransferManager.Result.VALID;
    }

    function canTransfer(address _from, address _to, uint256 _amount, bytes calldata _data) external view returns(ITransferManager.Result result, byte status, bytes32 partition) {
        if (_isPausable()) return (ITransferManager.Result.INVALID, StatusCodes.code(StatusCodes.Status.TransfersHalted), bytes32(0));
        return (ITransferManager.Result.VALID, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
    }
}