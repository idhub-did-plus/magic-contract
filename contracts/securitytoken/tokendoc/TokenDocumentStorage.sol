pragma solidity 0.5.8;

contract TokenDocumentStorage {
    address internal _owner;

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
}