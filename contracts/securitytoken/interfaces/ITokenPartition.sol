pragma solidity 0.5.8;

// import "./TokenPartitionStorage.sol";
import "../libraries/SafeMath.sol";
import "./tokens/IERC1410.sol";

interface ITokenPartition {
    function isAuthorizedTransfer(bytes32 _partition, address _tokenHolder) external view;

    // Token Information
    function balanceOfByPartition(bytes32 _partition, address _tokenHolder) external view returns (uint256);

    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory);

    // Token Transfers
    function transferByPartition(bytes32 _partition, address _from, address _to, uint256 _value, bytes calldata _data) external returns (bytes32);

    function operatorTransferByPartition(bytes32 _partition, address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external returns (bytes32);

    function canTransferByPartition(address _from, address _to, bytes32 _partition, uint256 _value, bytes calldata _data) external view returns (byte, bytes32, bytes32);
    
    // Operator Information
    // These functions are present in the STGetter
    function isOperator(address _operator, address _tokenHolder) external view returns (bool);

    function isOperatorForPartition(bytes32 _partition, address _operator, address _tokenHolder) external view returns (bool);

    // Operator Management
    function authorizeOperator(address _operator, address _tokenHolder) external;

    function revokeOperator(address _operator, address _tokenHolder) external;

    function authorizeOperatorByPartition(bytes32 _partition, address _operator, address _tokenHolder) external;

    function revokeOperatorByPartition(bytes32 _partition, address _operator, address _tokenHolder) external;

    // Issuance / Redemption
    function issueByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data) external;

    function redeemByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data) external;

    function operatorRedeemByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external;
}