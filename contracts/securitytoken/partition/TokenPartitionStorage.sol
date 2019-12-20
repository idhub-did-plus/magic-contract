pragma solidity 0.5.8;

contract TokenPartitionStorage {
    address internal _owner;

    //////////////////////////
    /// Document datastructure
    //////////////////////////
    
    // mapping to store the documents details in the document
    mapping(bytes32 => Partition) public partitions;
    // mapping to store the document name indexes
    mapping(bytes32 => uint256) public partitionIndexs;

    mapping(address => address[]) public operators;
    mapping(address => mapping(address => uint)) public operatorIndexs;

    // Array use to store all the document name present in the contracts
    bytes32[] public partitionNames;

    struct Partition {
        bytes32 docName; // Name of the related document
        mapping(address => address[]) operators;
        mapping(address => uint) balances;
        mapping(address => mapping(address => uint)) operatorIndexs;
    }
}