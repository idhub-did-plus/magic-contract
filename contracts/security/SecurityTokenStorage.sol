pragma solidity 0.5.8;

import "./interfaces/ITokenStore.sol";
import "./interfaces/ITokenDocument.sol";
import "./interfaces/ITokenPartition.sol";
import "./interfaces/ITransferManager.sol";
import "./interfaces/ITokenController.sol";
import "./libraries/StatusCodes.sol";
import "./libraries/SafeMath.sol";

contract SecurityTokenStorage {

    uint8 internal constant PERMISSION_KEY = 1;
    uint8 internal constant TRANSFER_KEY = 2;
    uint8 internal constant MINT_KEY = 3;
    uint8 internal constant CHECKPOINT_KEY = 4;
    uint8 internal constant BURN_KEY = 5;
    uint8 internal constant DATA_KEY = 6;
    uint8 internal constant WALLET_KEY = 7;

    bytes32 internal constant WHITELIST = "WHITELIST";
    bytes32 internal constant INVESTORSKEY = 0xdf3a8dd24acdd05addfc6aeffef7574d2de3f844535ec91e8e0f3e45dba96731; //keccak256(abi.encodePacked("INVESTORS"))

    address public securityToken;

    // Partition ERC20 Details
    mapping(address => string) internal names;
    mapping(address => string) internal symbols;
    mapping(address => uint8) internal decimals;
    mapping(address => uint) internal totalSupplys;
    mapping(address => mapping (address => uint)) internal balances;
    mapping (address => mapping(address => mapping (address => uint))) internal allowances;

    /////////////////////////////
    /// Partition datastructure
    /////////////////////////////

    mapping(bytes32 => bytes32) public docNamesOfPartition;
    mapping(bytes32 => address) public partitionToAddress;
    // mapping to store the partition name indexes
    mapping(bytes32 => uint256) public partitionIndexs;

    bytes32[] public partitionNames;


    ///////////////////////////////
    /// Permission datastructure
    //////////////////////////////

    mapping(address => mapping(address => mapping(address => mapping(bytes32 => bool))) perms;

    // permissions[contract-address][from-address][to-address][perm-name] => bool


    //////////////////////////
    /// Document datastructure
    //////////////////////////
    
    // mapping to store the documents details in the document
    mapping(bytes32 => Document) internal _documents;
    // mapping to store the document name indexes
    mapping(bytes32 => uint256) internal _docIndexes;

    // Array use to store all the document name present in the contracts
    bytes32[] _docNames;

    struct Document {
        bytes32 docHash; // Hash of the document
        uint256 lastModified; // Timestamp at which document details was last modified
        string uri; // URI of the document that exist off-chain
    }

/*
    /////////////////////////////
    /// Controller datastructure
    /////////////////////////////

    address[] public controllers;
    mapping(address => uint) public controllerIndexes;
*/

    //////////////////////////
    /// Module datastructure
    //////////////////////////

    struct Module {
        uint256 index;
        address module;
        address moduleFactory;
        uint8[] types;
        uint256[] indexes;
    }

    mapping(address => address[]) public modules;
    mapping(address => mapping(address => Module)) public modulesByAddress;
    mapping(address => mapping(uint8 => address[])) public modulesByType;

    mapping(address => uint) public holderCounts;

    address public owner;

    uint256 public granularity;
    // Number of investors with non-zero balance
    // uint256 public holderCount;

    bool internal isHalted;
    bool internal issuable;

}
