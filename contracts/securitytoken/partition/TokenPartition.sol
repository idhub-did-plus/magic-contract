pragma solidity 0.5.8;

import "./TokenPartitionStorage.sol";
import "../libraries/SafeMath.sol";
import "../libraries/StatusCodes.sol";
import "../interfaces/tokens/IERC1410.sol";

contract TokenPartition is TokenPartitionStorage, IERC1410 {
    using SafeMath for uint256;

    function isAuthorizedTransfer(bytes32 _partition, address _tokenHolder) external view {
        _isAuthorizedTransfer(_partition, _tokenHolder);
    }

    function setPartition(bytes32 _partition, bytes32 _docName) external {
        require(msg.sender == _owner, "Invalid Owner");
        _setPartition(_partition, _docName);
    }

    // Token Information
    function balanceOfByPartition(bytes32 _partition, address _tokenHolder) external view returns (uint256) {
        return partitions[_partition].balances[_tokenHolder];
    }

    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory) {
        uint count;
        // bytes32[] memory _partitionNames = new bytes32[](partitionNames.length);
        for (uint i=0; i<partitionNames.length; i++) {
            if (partitions[partitionNames[i]].balances[_tokenHolder] != 0) {
                count += 1;
                // _partitionNames.push(partitionNames[i]);
            }
        }
        bytes32[] memory _partitionNames = new bytes32[](count);
        count = 0;
        for (uint i=0; i<partitionNames.length; i++) {
            if (partitions[partitionNames[i]].balances[_tokenHolder] != 0) {
                // count += 1;
                _partitionNames[count] = partitionNames[i];
                count += 1;
            }
        }
        return _partitionNames;
    }

    // Token Transfers
    function transferByPartition(bytes32 _partition, address _from, address _to, uint256 _value, bytes calldata _data) external returns (bytes32) {
        // address _from = address(uint160(_data));
        _isAuthorizedTransfer(_partition, _from);
        require(partitions[_partition].balances[_from] >= _value, "Insufficient Partition Balances");
        partitions[_partition].balances[_from].sub(_value);
        partitions[_partition].balances[_to].add(_value);
        // emit TransferByPartition(sender, recipient, amount);
        return _partition;
    }

    function operatorTransferByPartition(bytes32 _partition, address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external returns (bytes32) {
        _isAuthorizedTransfer(_partition, _from);
        require(partitions[_partition].balances[_from] >= _value, "Insufficient Partition Balances");
        partitions[_partition].balances[_from].sub(_value);
        partitions[_partition].balances[_to].add(_value);
        return _partition;
    }

    function canTransferByPartition(address _from, address _to, bytes32 _partition, uint256 _value, bytes calldata _data) external view returns (byte, bytes32, bytes32) {
        if (partitions[_partition].balances[_from] >= _value) {
            return (StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0), _partition);
        } else return (StatusCodes.code(StatusCodes.Status.InsufficientBalance), _partition, _partition);
    }
    
    // Operator Information
    // These functions are present in the STGetter
    function isOperator(address _operator, address _tokenHolder) external view returns (bool) {
        return _isOperator(_operator, _tokenHolder);
    }

    function isOperatorForPartition(bytes32 _partition, address _operator, address _tokenHolder) external view returns (bool) {
        return _isOperatorForPartition(_partition, _operator, _tokenHolder);
    }

    // Operator Management
    function authorizeOperator(address _operator, address _tokenHolder) external {
        require(msg.sender == _owner, "Invalid Owner");
        operators[_tokenHolder].push(_operator);
        operatorIndexs[_tokenHolder][_operator] = operators[_tokenHolder].length;
    }

    function revokeOperator(address _operator, address _tokenHolder) external {
        require(msg.sender == _owner, "Invalid Owner");
        uint index = operatorIndexs[_tokenHolder][_operator];
        require(index != 0, "Operator Not Existed");
        delete operators[_tokenHolder][index-1];
        delete operatorIndexs[_tokenHolder][_operator];
    }

    function authorizeOperatorByPartition(bytes32 _partition, address _operator, address _tokenHolder) external {
        require(partitionIndexs[_partition] != 0, "Partition Not Existed");
        require(msg.sender == _owner, "Invalid Owner");
        partitions[_partition].operators[_tokenHolder].push(_operator);
        partitions[_partition].operatorIndexs[_tokenHolder][_operator] = partitions[_partition].operators[_tokenHolder].length;
    }

    function revokeOperatorByPartition(bytes32 _partition, address _operator, address _tokenHolder) external {
        require(partitionIndexs[_partition] != 0, "Partition Not Existed");
        require(msg.sender == _owner, "Invalid Owner");
        uint index = partitions[_partition].operatorIndexs[_tokenHolder][_operator];
        require(index != 0, "Operator Not Existed");
        delete partitions[_partition].operators[_tokenHolder][index-1];
        delete partitions[_partition].operatorIndexs[_tokenHolder][_operator];
    }

    // Issuance / Redemption
    function issueByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data) external {
        require(msg.sender == _owner, "Invalid Owner");
        if (partitionIndexs[_partition] == 0) _setPartition(_partition, bytes32(0));
        partitions[_partition].balances[_tokenHolder].add(_value);
    }

    function redeemByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data) external {
        require(msg.sender == _owner, "Invalid Owner");
        require(partitionIndexs[_partition] != 0, "Partition Not Existed");
        // address _tokenHolder = address(uint160(_data));
        // if (partitionIndexs[_partition] == 0) setPartition(_partition, _data);
        partitions[_partition].balances[_tokenHolder].sub(_value);
    }

    function operatorRedeemByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external {
        _isAuthorizedTransfer(_partition, _tokenHolder);
        require(partitionIndexs[_partition] != 0, "Partition Not Existed");
        partitions[_partition].balances[_tokenHolder].sub(_value);
    }

    function _isAuthorizedTransfer(bytes32 _partition, address _tokenHolder) internal view {
        require(msg.sender == _owner || _isOperator(msg.sender, _tokenHolder) || _isOperatorForPartition(_partition, msg.sender, _tokenHolder),
            "Not An Authorized Transfer Caller");
    }

    function _isOperator(address _operator, address _tokenHolder) internal view returns (bool) {
        for (uint i=0; i<operators[_tokenHolder].length; i++) {
            if (_operator == operators[_tokenHolder][i]) return true;
        }
        return false;
    }

    function _isOperatorForPartition(bytes32 _partition, address _operator, address _tokenHolder) internal view returns (bool) {
        for (uint i=0; i<partitions[_partition].operators[_tokenHolder].length; i++) {
            if (_operator == partitions[_partition].operators[_tokenHolder][i]) return true;
        }
        return false; 
    }
    
    function _setPartition(bytes32 _partition, bytes32 _docName) internal {
        // bytes32 docName = bytes32(_data);
        Partition memory partition = Partition(_docName);
        partitionNames.push(_partition);
        partitions[_partition] = partition;
        partitionIndexs[_partition] = partitionNames.length;
    }

}