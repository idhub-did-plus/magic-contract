pragma solidity 0.5.8;

import "./SecurityTokenStorage.sol";
import "./datastore/DataStore.sol";

contract SecurityTokenStore is SecurityTokenStorage, DataStore  {
    function _isAuthorized() internal view {
        require(msg.sender == _owner, "Unauthorized");
    }
    // data getter

    //////////////////////////
    /// Document Fuctions
    //////////////////////////

    function getDocNames() external view returns(bytes32[] memory) {
        return _docNames;
    }

    function getDocument(bytes32 _name) external view returns (string memory, bytes32, uint256) {
        return (_documents[_name].uri, _documents[_name].docHash, _documents[_name].lastModified);
    }


    function getName(address _partition) external view returns(string memory) {
        return names[_partition];
    }

    function getSymbol(address _partition) external view returns(string memory) {
        return symbols[_partition];
    }

    function getDecimals(address _partition) external view returns(uint8) {
        return decimals[_partition];
    }

    function getTotalSupply(address _partition) external view returns(uint) {
        return totalSupplys[_partition];
    }

    function getBalances(address _partition, address _holder) external view returns(uint) {
        return balances[_partition][_holder];
    }

    function getAllowances(address _partition, address _from, address _to) external view returns(uint) {
        return allowances[_partition][_from][_to];
    }

    // data setter

    //////////////////////////
    /// Document Fuctions
    //////////////////////////

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
        if (document[name].lastModified == uint256(0)) {
            // check if exists bug? 
            // index start from 1
            docNames.push(name);
            docIndexes[name] = docNames.length;
            // docNames.push(name);
        }
        document[name] = Document(documentHash, now, uri);
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
        delete document[name];
    }


    function setName(address _partition, string calldata _name) external {
        _isAuthorized();
        names[_partition] = _name;
    }

    function setSymbol(address _partition, string calldata _symbol) external {
        _isAuthorized();
        symbols[_partition] = _symbol;
    }

    function setDecimals(address _partition, uint8 _decimals) external {
        _isAuthorized();
        decimals[_partition] = _decimals;
    }

    function setTotalSupply(address _partition, uint _totalSupply) external {
        _isAuthorized();
        totalSupplys[_partition] = _totalSupply;
    }

    function setBalances(address _partition, address _holder, uint _amount) external {
        _isAuthorized();
        balances[_partition][_holder] = _amount;
    }

    function setAllowances(address _partition, address _from, address _to, uint _amount) external {
        _isAuthorized();
        allowances[_partition][_from][_to] = _amount;
    }

    // mutil data setter
    function setBalancesMulti(address _partition, address[] calldata _holders, uint[] calldata _amounts) external {
        _isAuthorized();
        for (uint256 i = 0; i < _holders.length; i++) {
            balances[_partition][_holders[i]] = _amounts[i];
        }
    }

    function setAllowancesMulti(address _partition, address[] calldata _from, address[] calldata _to, uint[] calldata _amounts) external {
        _isAuthorized();
        for (uint256 i = 0; i < _from.length; i++) {
            allowances[_partition][_from[i]][_to[i]] = _amounts[i];
        }
    }
}

