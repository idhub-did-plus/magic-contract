pragma solidity 0.5.8;

contract DataStoreStorage {
    // 建议securityToken和_owner设为同一地址
    // address public securityToken;
    address internal _owner;

    mapping (bytes32 => uint256) internal uintData;
    mapping (bytes32 => bytes32) internal bytes32Data;
    mapping (bytes32 => address) internal addressData;
    mapping (bytes32 => string) internal stringData;
    mapping (bytes32 => bytes) internal bytesData;
    mapping (bytes32 => bool) internal boolData;

    mapping (bytes32 => uint256[]) internal uintArrayData;
    mapping (bytes32 => bytes32[]) internal bytes32ArrayData;
    mapping (bytes32 => address[]) internal addressArrayData;
    mapping (bytes32 => bool[]) internal boolArrayData;
}
