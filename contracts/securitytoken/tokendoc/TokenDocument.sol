pragma solidity 0.5.8;
pragma experimental ABIEncoderV2;

import "./TokenDocumentStorage.sol";

contract TokenDocument is TokenDocumentStorage {
    // Document Events
    event DocumentRemoved(bytes32 indexed _name, string _uri, bytes32 _documentHash);
    event DocumentUpdated(bytes32 indexed _name, string _uri, bytes32 _documentHash);

    function _isAuthorized() internal view {
        /*require(msg.sender == address(securityToken) ||
            msg.sender == IOwnable(address(securityToken)).owner() ||
            securityToken.checkPermission(msg.sender, address(this), MANAGEDATA) ||
            securityToken.isModule(msg.sender, DATA_KEY),
            "Unauthorized"
        );*/
        require(msg.sender == _owner, "Unauthorized");
    }

    function docNames() external view returns(bytes32[] memory) {
        return _docNames;
    }

    function getAllDocuments() external view returns (bytes32[] memory) {
        // _isAuthorized();
        /*Document[] memory documents = new Document[](_docNames.length);
        for (uint i=0; i<_docNames.length; i++) {
            documents[i] = _documents[_docNames[i]];
        }*/
        return _docNames;
    }

    function getDocument(bytes32 _name) external view returns (string memory, bytes32, uint256) {
        // _isAuthorized();
        return (_documents[_name].uri, _documents[_name].docHash, _documents[_name].lastModified);
    }
    /**
     * @notice Used to attach a new document to the contract, or update the URI or hash of an existing attached document
     * @dev Can only be executed by the owner of the contract.
     * @param _name Name of the document. It should be unique always
     * @param _uri Off-chain uri of the document from where it is accessible to investors/advisors to read.
     * @param _documentHash hash (of the contents) of the document.
     */
    function setDocument(bytes32 _name, string calldata _uri, bytes32 _documentHash) external {
        _isAuthorized();
        _setDocument(_documents, _docNames, _docIndexes, _name, _uri, _documentHash);
    }

    /**
     * @notice Used to remove an existing document from the contract by giving the name of the document.
     * @dev Can only be executed by the owner of the contract.
     * @param _name Name of the document. It should be unique always
     */
    function removeDocument(bytes32 _name) external {
        _isAuthorized();
        _removeDocument(_documents, _docNames, _docIndexes, _name);
    }

    /**
     * @notice Used to attach a new document to the contract, or update the URI or hash of an existing attached document
     * @param name Name of the document. It should be unique always
     * @param uri Off-chain uri of the document from where it is accessible to investors/advisors to read.
     * @param documentHash hash (of the contents) of the document.
     */
    function _setDocument(
        mapping(bytes32 => Document) storage document,
        bytes32[] storage docNames,
        mapping(bytes32 => uint256) storage docIndexes,
        bytes32 name,
        string memory uri,
        bytes32 documentHash
    )
        internal
    {
        require(name != bytes32(0), "Bad name");
        require(bytes(uri).length > 0, "Bad uri");
        if (document[name].lastModified == uint256(0)) {
            // check if exists bug? 
            // index start from 1
            docNames.push(name);
            docIndexes[name] = docNames.length;
            // docNames.push(name);
        }
        document[name] = Document(documentHash, now, uri);
        emit DocumentUpdated(name, uri, documentHash);
    }

    /**
     * @notice Used to remove an existing document from the contract by giving the name of the document.
     * @dev Can only be executed by the owner of the contract.
     * @param name Name of the document. It should be unique always
     */
    function _removeDocument(
        mapping(bytes32 => Document) storage document,
        bytes32[] storage docNames,
        mapping(bytes32 => uint256) storage docIndexes,
        bytes32 name
    )
        internal
    {
        require(document[name].lastModified != uint256(0), "Not existed");
        uint256 index = docIndexes[name] - 1;
        if (index != docNames.length - 1) {
            docNames[index] = docNames[docNames.length - 1];
            docIndexes[docNames[index]] = index + 1;
        }
        docNames.length--;
        emit DocumentRemoved(name, document[name].uri, document[name].docHash);
        delete document[name];
        // DocumentRemoved(name, document[name].uri, document[name].docHash);
    }
}