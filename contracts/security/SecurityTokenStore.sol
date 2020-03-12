pragma solidity 0.5.8;

import "./SecurityTokenStorage.sol";
import "./datastore/DataStore.sol";
import "./interfaces/ITransferManager.sol";
import "./partition/Partition.sol";
import "./partition/PartitionLogic.sol";

contract SecurityTokenStore is SecurityTokenStorage, DataStore  {
    using SafeMath for uint256;

    function _isAuthorized() internal view {
        require(msg.sender == _owner, "Unauthorized");
    }

    constructor() public {
        _owner = msg.sender;
    }

    function changeOwner(address _newOwner) external onlyOwner {
        _owner = _newOwner;
    }

    function getPermission(
        address _partition,
        address _from,
        address _to,
        byte32 _perm
    ) 
        external 
        view 
        returns (bool) 
    {
        return perms[_partition][_from][_to][_perm];
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

    function getGranularity(address _partition) external view returns(uint) {
        return granularity[_partition];
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

    function getIssuable() external view returns (bool) {
        return issuable;
    }

    // data setter

    function issue(address _partition, address _tokenHolder, uint256 _value) external {
        _isAuthorized();
        balances[_partition][_tokenHolder] = balances[_partition][_tokenHolder].add(_value);
        totalSupplys[_partition] = totalSupplys[_partition].add(_value);
        _adjustInvestorCount(_partition, address(0), _tokenHolder, _value, _balanceOf(_tokenHolder), 0);
    }

    function setIssuable(bool _issuable) external {
        _isAuthorized();
        issuable = _issuable;
    }

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


    function setPermission(
        address _partition,
        address _from,
        address _to,
        byte32 _perm,
        bool _value
    ) 
        external  
    {
        _isAuthorized();
        perms[_partition][_from][_to][_perm] = _value;
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

    // granularity
    function setGranularity(address _partition, uint _granularity) external {
        _isAuthorized();
        granularity[_partition] = _granularity;
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
        _setBalancesMulti(_partition, _holders, _amounts);
    }

    function _setBalancesMulti(address _partition, address[] calldata _holders, uint[] calldata _amounts) internal {
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


    /////////////////////////////
    // Modules Fuctions
    /////////////////////////////

    function addModule(address _partition, address _module) external {
        _isAuthorized();
        require(modulesByAddress[_partition][_module].module == address(0), "Module Existed");
        modules[_partition].push(_module);
        uint8[] memory types = IModule(_module).getTypes();
        uint256[] memory indexes = new uint256[](types.length);
        for (uint i=0; i<types.length; i++) {
            modulesByType[_partition][types[i]].push(_module);
            indexes[i] = modulesByType[_partition][types[i]].length;
        }
        Module memory module = Module(modules.length, _module, address(0), types, indexes);
        modulesByAddress[_partition][_module] = module;
    }

    function removeModule(address _partition, address _module) external {
        _isAuthorized();
        require(modulesByAddress[_partition][_module].module != address(0), "Module Not Existed");
        uint index = modulesByAddress[_partition][_module].index - 1;
        if (index != modules.length - 1) {
            modules[_partition][index] = modules[_partition][modules.length - 1];
        }
        modules[_partition].length--;
        uint8[] memory types = modulesByAddress[_partition][_module].types;
        for (uint i=0; i<types.length; i++) {
            address[] storage modulesPoint = modulesByType[_partition][types[i]];
            uint index = modulesByAddress[_partition][_module].indexes[i];
            if (index != modulesPoint.length - 1) {
                modulesPoint[index] = modulesPoint[modulesPoint.length - 1];
            }
            modulesPoint.length--;
        }
        delete modulesByAddress[_partition][_module];
        // delete modulesByType[_module];
    }


    //////////////////////////
    /// Partition Fuctions
    //////////////////////////

    function setPartition(address _partitionAddress, bytes32 _partition, bytes32 _docName) external {
        _isAuthorized();
        _setPartition(_partitionAddress, _partition, _docName);
    }

    function getPartitionAddress(bytes32 _partition) external view returns (address) {
        return partitionToAddress[_partition];
    }

    // Token Information
    function balanceOfByPartition(bytes32 _partition, address _tokenHolder) external view returns (uint256) {
        return _balanceOfByPartition(_partition, _tokenHolder);
    }

    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory) {
        uint count;
        // bytes32[] memory _partitionNames = new bytes32[](partitionNames.length);
        for (uint i=0; i<partitionNames.length; i++) {
            if (_balanceOfByPartition(partitionNames[i], _tokenHolder) != 0) {
                count += 1;
                // _partitionNames.push(partitionNames[i]);
            }
        }
        bytes32[] memory _partitionNames = new bytes32[](count);
        count = 0;
        for (uint i=0; i<partitionNames.length; i++) {
            if (_balanceOfByPartition(partitionNames[i], _tokenHolder) != 0) {
                // count += 1;
                _partitionNames[count] = partitionNames[i];
                count += 1;
            }
        }
        return _partitionNames;
    }

    function _balanceOfByPartition(bytes32 _partition, address _tokenHolder) internal view returns (uint256) {
        return balances[partitionToAddress[_partition]][_tokenHolder];
    }
    
    function _setPartition(addresss _partitionAddress, bytes32 _partition, bytes32 _docName) internal {
        // bytes32 docName = bytes32(_data);
        partitionToAddress[_partition] = _partitionAddress;
        docNamesOfPartition[_partition] = _docName;
        partitionNames.push(_partition);
        partitionIndexs[_partition] = partitionNames.length;
    }


    //////////////////////////
    /// Transfer Fuctions
    //////////////////////////

    function canTransfer(
        address _partition,
        address _caller,
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        external 
    {
        _isAuthorized();
        _canTransfer(modulesByType[_partition][TRANSFER_KEY], _partition, _caller, _from, _to, _value, _data);
    }

    function transferWithData(
        address _partition,
        address _caller,
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        external 
    {
        _isAuthorized();
        _transferWithData(modulesByType[_partition][TRANSFER_KEY], _partition, _caller, _from, _to, _value, _data);
    }

    function _canTransfer(
        address[] memory _modules,
        address _partition,
        address _caller,
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        internal 
        view 
        checkGranularity(_value) 
        returns(byte, bytes32) 
    {
        // bool isInvalid = false;
        // bool isValid = false;
        // bool isForceValid = false;
        (bool isInvalid, byte status, bytes32 appCode) = _checkInsufficient(_partition, _caller, _from, _to, _value);
        if (isInvalid) return (status, appCode);
        // Use the local variables to avoid the stack too deep error
        // bytes32 appCode = bytes32(0);
        for (uint256 i = 0; i < _modules.length; i++) {
            (ITransferManager.Result valid, byte error, bytes32 reason) = ITransferManager(_modules[i]).canTransfer(_partition, _from, _to, _value, _data);
            if (valid == ITransferManager.Result.INVALID) {
                // isInvalid = true;
                appCode = reason;
                status = error;
            } /*else if (valid == ITransferManager.Result.VALID) {
                isValid = true;
            } else if (valid == ITransferManager.Result.FORCE_VALID) {
                isForceValid = true;
            }*/
        }
        // Use the local variables to avoid the stack too deep error
        // isValid = isForceValid ? true : (isInvalid ? false : isValid);

        // Balance overflow can never happen due to totalsupply being a uint256 as well
        // else if (!KindMath.checkAdd(balanceOf(_to), _value))
        //     return (0x50, bytes32(0));
        return (status, appCode);
        // return (isValid, isValid ? bytes32(StatusCodes.code(StatusCodes.Status.TransferSuccess)): appCode);
    }

    function _transferWithData(
        address[] memory _modules,
        address _partition,
        address _caller,
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        internal 
    {
        // bool isInvalid = false;
        bool isValid = true;
        bool isForceValid = false;
        (bool isInvalid, byte status, bytes32 appCode) = _checkInsufficient(_partition, _caller, _from, _to, _value);
        require(!isInvalid);
        // Use the local variables to avoid the stack too deep error
        // bytes32 appCode = bytes32(0);
        for (uint256 i = 0; i < _modules.length; i++) {
            // (ITransferManager.Result valid, byte error, bytes32 reason) = ITransferManager(_modules[i]).transfer(_from, _to, _value, _data);
            ITransferManager.Result valid = ITransferManager(_modules[i]).transfer(_partition, _from, _to, _value, _data);
            if (valid == ITransferManager.Result.INVALID) {
                isInvalid = true;
                // appCode = reason;
                // status = error;
            } else if (valid == ITransferManager.Result.VALID) {
                isValid = true;
            } else if (valid == ITransferManager.Result.FORCE_VALID) {
                isForceValid = true;
            }
        }
        // Use the local variables to avoid the stack too deep error
        isValid = isForceValid ? true : (isInvalid ? false : isValid);

        _adjustInvestorCount(_partition, _from, _to, _value, balances[_partition][_to], balances[_partition][_from]);

        if (isValid == true) {
            uint[] memory amounts = new uint[](2);
            amounts[0] = balances[_partition][_from].sub(_value);
            amounts[1] = balances[_partition][_to].add(_value);
            address[] memory holders = new address[](2);
            holders[0] = _from;
            holders[1] = _to;
            _setBalancesMulti(_partition, holders, amounts);
        }

        _isValidTransfer(isValid);
        // Balance overflow can never happen due to totalsupply being a uint256 as well
        // else if (!KindMath.checkAdd(balanceOf(_to), _value))
        //     return (0x50, bytes32(0));
        // return (status, appCode);
        // return (isValid, isValid ? bytes32(StatusCodes.code(StatusCodes.Status.TransferSuccess)): appCode);
    }

    function _checkInsufficient(address _partition, address _caller, address _from, address _to, uint _value) internal view returns(bool, byte, bytes32) {
        if (balances[_partition][_from] < _value) return(true, StatusCodes.code(StatusCodes.Status.InsufficientBalance), bytes32(0));
        if (_caller != _from && allowances[_partition][_from][_caller] < _value) return(true, StatusCodes.code(StatusCodes.Status.InsufficientAllowance), bytes32(0));
        return(false, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
    }

    function _isValidTransfer(bool _isTransfer) internal pure {
        require(_isTransfer, "Transfer Invalid");
    }

    function _adjustInvestorCount(
        address _partition,
        address _from,
        address _to,
        uint256 _value,
        uint256 _balanceTo,
        uint256 _balanceFrom
    )
        internal 
    {
        // uint256 holderCount = _holderCount;
        if ((_value == 0) || (_from == _to)) {
            return;
        }
        // Check whether receiver is a new token holder
        if ((_balanceTo == 0) && (_to != address(0))) {
            holderCounts[_partition] = holderCounts[_partition].add(1);
            if (!_isExistingInvestor(_partition, _to)) {
                insertAddress(_getKey(INVESTORSKEY, _partition), _to);
                //KYC data can not be present if added is false and hence we can set packed KYC as uint256(1) to set added as true
                setUint256(_getKey(WHITELIST, _partition, _to), uint256(1));
            }
        }
        // Check whether sender is moving all of their tokens
        if (_value == _balanceFrom) {
            holderCounts[_partition] = holderCount[_partition].sub(1);
        }
        return;
    }

    function _isExistingInvestor(address _partition, address _investor) internal view returns(bool) {
        uint256 data = getUint256(_getKey(WHITELIST, _partition, _investor));
        //extracts `added` from packed `whitelistData`
        return uint8(data) == 0 ? false : true;
    }

    function _getKey(bytes32 _key1, address _key2) internal pure returns(bytes32) {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }

    function _getKey(bytes32 _key1, address _key2, address _key3) internal pure returns(bytes32) {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2, _key3)));
    }
}

