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

    ITokenStore public tokenStore;
    ITokenDocument public tokenDocument;
    ITokenPartition public tokenPartition;
    ITokenController public tokenController;

    // module
    struct Module {
        uint256 index;
        address module;
        address moduleFactory;
        uint8[] types;
        uint256[] indexes;
    }

    address public owner;

    uint256 public granularity;
    // Number of investors with non-zero balance
    uint256 public holderCount;

    address[] public modules;
    mapping(address => Module) public modulesByAddress;
    mapping(uint8 => address[]) public modulesByType;

    bool internal isHalted;
    bool internal issuable;

}
