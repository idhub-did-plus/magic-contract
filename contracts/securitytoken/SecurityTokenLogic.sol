pragma solidity 0.5.8;

import "./interfaces/ITokenStore.sol";
import "./interfaces/ITokenDocument.sol";
import "./interfaces/ITokenPartition.sol";
import "./interfaces/ITransferManager.sol";
import "./interfaces/ITokenController.sol";
import "./interfaces/IModule.sol";
import "./interfaces/tokens/IERC1410.sol";
import "./interfaces/tokens/IERC1594.sol";
import "./interfaces/tokens/IERC1643.sol";
import "./interfaces/tokens/IERC1644.sol";
import "./interfaces/tokens/IERC20.sol";
import "./libraries/StatusCodes.sol";
import "./libraries/SafeMath.sol";
import "./SecurityTokenStorage.sol";
import "./tokendoc/TokenDocumentStorage.sol";

contract SecurityTokenLogic is SecurityTokenStorage, IERC20, IERC1410, IERC1594, IERC1643, IERC1644 {
    using SafeMath for uint256;


    /////////////////////////////
    // ERC20Interfaces
    /////////////////////////////

    function name() external view returns (string memory) {
        return _name();
    }

    function symbol() external view returns (string memory) {
        return _symbol();
    }

    function decimals() external view returns (uint8) {
        return _decimals();
    }

    function totalSupply() external view returns (uint256) {
    	return _totalSupply();
    }

    function balanceOf(address account) external view returns (uint256) {
    	return _balanceOf(account);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowance(owner, spender);
    }

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool) {
        _transferWithData(modulesByType[TRANSFER_KEY], msg.sender, recipient, amount, new bytes(0));
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        ITokenStore(tokenStore).setAllowances(msg.sender, spender, amount);
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        _transferWithData(modulesByType[TRANSFER_KEY], sender, recipient, amount, new bytes(0));
        emit Transfer(sender, recipient, amount);
        return true;
    }


    /////////////////////////////
    // ERC1594Interfaces
    /////////////////////////////

    // Transfer Validity
    function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        return _canTransfer(modulesByType[TRANSFER_KEY], msg.sender, _to, _value, _data);
    }

    function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        return _canTransfer(modulesByType[TRANSFER_KEY], _from, _to, _value, _data);
    }

    // Transfers
    function transferWithData(address _to, uint256 _value, bytes calldata _data) external {
        _transferWithData(modulesByType[TRANSFER_KEY], msg.sender, _to, _value, _data);
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFromWithData(address _from, address _to, uint256 _value, bytes calldata _data) external {
        _transferWithData(modulesByType[TRANSFER_KEY], _from, _to, _value, _data);
        emit Transfer(_from, _to, _value);
    }

    // Token Issuance
    function isIssuable() external view returns (bool) {
        return _isIssuable();
    }

    function issue(address _tokenHolder, uint256 _value, bytes calldata _data) external {
        require(_isIssuable(), "Security Can Not Issue");
        ITokenStore(tokenStore).setBalances(_tokenHolder, _balanceOf(_tokenHolder).add(_value));
        ITokenStore(tokenStore).setTotalSupply(_totalSupply().add(_value));
    }

    // Token Redemption
    function redeem(uint256 _value, bytes calldata _data) external {
        ITokenStore(tokenStore).setBalances(msg.sender, _balanceOf(msg.sender).sub(_value));
        ITokenStore(tokenStore).setTotalSupply(_totalSupply().sub(_value));
    }

    function redeemFrom(address _tokenHolder, uint256 _value, bytes calldata _data) external{
        ITokenStore(tokenStore).setBalances(_tokenHolder, _balanceOf(_tokenHolder).sub(_value));
        ITokenStore(tokenStore).setTotalSupply(_totalSupply().sub(_value));
    }


    /////////////////////////////
    // ERC1644Interfaces 
    /////////////////////////////

    function isControllable() external view returns (bool) {
        tokenController.isControllable(msg.sender);
    }

    function controllerTransfer(address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external {
        tokenController.controllerTransfer(_from, _to, _value, _data, _operatorData);
        emit ControllerTransfer(msg.sender, _from, _to, _value, _data, _operatorData);
    }

    function controllerRedeem(address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external {
        tokenController.controllerRedeem(_tokenHolder, _value, _data, _operatorData);
        emit ControllerRedemption(msg.sender, _tokenHolder, _value, _data, _operatorData);
    }


    /////////////////////////////
    // ERC1643Interfaces 
    /////////////////////////////

    function getDocument(bytes32 _name) external view returns (string memory, bytes32, uint256) {
        return tokenDocument.getDocument(_name);
        
    }

    function getAllDocuments() external view returns (bytes32[] memory) {
        /*TokenDocument.Document[] memory docs = tokenDocument.getAllDocument(_name);
        byte32[] memory hashes = new bytes32[](docs.length);
        for (uint i=0; i<docs.length; i++) hashes[i] = docs[i].docHash;
        return hashes;*/
        return tokenDocument.getAllDocuments();
    }

    function setDocument(bytes32 _name, string calldata _uri, bytes32 _documentHash) external {
        tokenDocument.setDocument(_name, _uri, _documentHash);
    }

    function removeDocument(bytes32 _name) external {
        tokenDocument.removeDocument(_name);
    }


    /////////////////////////////
    // ERC1410Interfaces 
    /////////////////////////////

    // Token Information
    // function balanceOf(address _tokenHolder) external view returns (uint256);
    function balanceOfByPartition(
        bytes32 _partition, 
        address _tokenHolder
    ) 
        external 
        view 
        returns (uint256) 
    {
        tokenPartition.balanceOfByPartition(_partition, _tokenHolder);
    }

    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory) {
        tokenPartition.partitionsOf(_tokenHolder);
    }
    // function totalSupply() external view returns (uint256);

    // Token Transfers
    function transferByPartition(
        bytes32 _partition, 
        address _to, 
        uint256 _value, 
        bytes calldata _data
    ) 
        external 
        returns (bytes32) 
    {
        // _data = bytes(uint160(msg.sender));
        tokenPartition.transferByPartition(_partition, msg.sender, _to, _value, _data);
        emit TransferByPartition(_partition, msg.sender, msg.sender, _to, _value, _data, new bytes(0));
    }

    function operatorTransferByPartition(
        bytes32 _partition, 
        address _from, 
        address _to, 
        uint256 _value, 
        bytes calldata _data, 
        bytes calldata _operatorData
    ) 
        external 
        returns (bytes32)
    {
        require(tokenPartition.isOperator(msg.sender, _from) || 
            tokenPartition.isOperatorForPartition(_partition, msg.sender, _from), 
            "Invalid Operator");
        tokenPartition.operatorTransferByPartition(_partition, _from, _to, _value, _data, _operatorData);
        emit TransferByPartition(_partition, msg.sender, _from, _to, _value, _data, _operatorData);
    }

    function canTransferByPartition(
        address _from, 
        address _to, 
        bytes32 _partition, 
        uint256 _value, 
        bytes calldata _data
    ) 
        external 
        view 
        returns (byte, bytes32, bytes32) 
    {
        tokenPartition.canTransferByPartition(_from, _to, _partition, _value, _data);
    }

    // Operator Information
    // These functions are present in the STGetter
    function isOperator(address _operator, address _tokenHolder) external view returns (bool) {
        tokenPartition.isOperator(_operator, _tokenHolder);
    }

    function isOperatorForPartition(bytes32 _partition, address _operator, address _tokenHolder) external view returns (bool) {
        tokenPartition.isOperatorForPartition(_partition, _operator, _tokenHolder);
    }

    // Operator Management
    function authorizeOperator(address _operator) external {
        tokenPartition.authorizeOperator(_operator, msg.sender);
        emit AuthorizedOperator(_operator, msg.sender);
    }

    function revokeOperator(address _operator) external {
        tokenPartition.revokeOperator(_operator, msg.sender);
        emit RevokedOperator(_operator, msg.sender);
    }

    function authorizeOperatorByPartition(bytes32 _partition, address _operator) external {
        tokenPartition.authorizeOperatorByPartition(_partition, _operator, msg.sender);
        emit AuthorizedOperatorByPartition(_partition, _operator, msg.sender);
    }

    function revokeOperatorByPartition(bytes32 _partition, address _operator) external {
        tokenPartition.authorizeOperatorByPartition(_partition, _operator, msg.sender);
        emit RevokedOperatorByPartition(_partition, _operator, msg.sender);
    }

    // Issuance / Redemption
    function issueByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data) external {
        tokenPartition.issueByPartition(_partition, _tokenHolder, _value, _data);
        emit IssuedByPartition(_partition, _tokenHolder, _value, _data);
    }

    function redeemByPartition(bytes32 _partition, uint256 _value, bytes calldata _data) external {
        tokenPartition.redeemByPartition(_partition, msg.sender, _value, _data);
        emit RedeemedByPartition(_partition, msg.sender, msg.sender, _value, _data, _data);
    }

    function operatorRedeemByPartition(
        bytes32 _partition, 
        address _tokenHolder, 
        uint256 _value, 
        bytes calldata _data, 
        bytes calldata _operatorData
    ) 
        external 
    {
        require(tokenPartition.isOperator(msg.sender, _tokenHolder) || 
            tokenPartition.isOperatorForPartition(_partition, msg.sender, _tokenHolder), 
            "Invalid Operator");
        tokenPartition.operatorRedeemByPartition(_partition, _tokenHolder, _value, _data, _operatorData);
    }

    /////////////////////////////
    // Modules 
    /////////////////////////////

    function addModule(address _module) external {
        require(modulesByAddress[_module].module == address(0), "Module Existed");
        require(_module != address(0), "Invalid Module");
        modules.push(_module);
        uint8[] memory types = IModule(_module).getTypes();
        uint256[] memory indexes = new uint256[](types.length);
        for (uint i=0; i<types.length; i++) {
            modulesByType[types[i]].push(_module);
            indexes[i] = modulesByType[types[i]].length;
        }
        Module memory module = Module(modules.length, _module, address(0), types, indexes);
        modulesByAddress[_module] = module;
    }

    function removeModule(address _module) external {
        require(modulesByAddress[_module].module != address(0), "Module Not Existed");
        uint index = modulesByAddress[_module].index - 1;
        if (index != modules.length - 1) {
            modules[index] = modules[modules.length - 1];
        }
        modules.length--;
        uint8[] memory types = modulesByAddress[_module].types;
        for (uint i=0; i<types.length; i++) {
            address[] storage modulesPoint = modulesByType[types[i]];
            uint index = modulesByAddress[_module].indexes[i];
            if (index != modulesPoint.length - 1) {
                modulesPoint[index] = modulesPoint[modulesPoint.length - 1];
            }
            modulesPoint.length--;
        }
        delete modulesByAddress[_module];
        // delete modulesByType[_module];
    }


    /////////////////////////////
    // Internal Functions 
    /////////////////////////////

    function _name() internal view returns (string memory) {
        return tokenStore.getName();
    }

    function _symbol() internal view returns (string memory) {
        return tokenStore.getSymbol();
    }

    function _decimals() internal view returns (uint8) {
        return tokenStore.getDecimals();
    }

    function _totalSupply() internal view returns (uint256) {
        return tokenStore.getTotalSupply();
    }

    function _balanceOf(address account) internal view returns (uint256) {
        return tokenStore.getBalances(account);
    }

    function _allowance(address owner, address spender) internal view returns (uint256) {
        return tokenStore.getAllowances(owner, spender);
    }
    
    function _isIssuable() internal view returns (bool) {
        return issuable;
    }

    function _checkInsufficient(address _caller, address _from, address _to, uint _value) internal view returns(bool, byte, bytes32) {
        if (_balanceOf(_from) < _value) return(true, StatusCodes.code(StatusCodes.Status.InsufficientBalance), bytes32(0));
        if (_caller != _from && _allowance(_from, _caller) < _value) return(true, StatusCodes.code(StatusCodes.Status.InsufficientAllowance), bytes32(0));
        return(false, StatusCodes.code(StatusCodes.Status.TransferSuccess), bytes32(0));
    }

    function _isValidTransfer(bool _isTransfer) internal pure {
        require(_isTransfer, "Transfer Invalid");
    }

    function _canTransfer(
        address[] memory _modules,
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        internal 
        view 
        returns(byte, bytes32) 
    {
        // bool isInvalid = false;
        // bool isValid = false;
        // bool isForceValid = false;
        (bool isInvalid, byte status, bytes32 appCode) = _checkInsufficient(msg.sender, _from, _to, _value);
        if (isInvalid) return (status, appCode);
        // Use the local variables to avoid the stack too deep error
        // bytes32 appCode = bytes32(0);
        for (uint256 i = 0; i < _modules.length; i++) {
            (ITransferManager.Result valid, byte error, bytes32 reason) = ITransferManager(_modules[i]).canTransfer(_from, _to, _value, _data);
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
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        internal 
        // view 
        // returns(byte, bytes32) 
    {
        // bool isInvalid = false;
        bool isValid = true;
        bool isForceValid = false;
        (bool isInvalid, byte status, bytes32 appCode) = _checkInsufficient(msg.sender, _from, _to, _value);
        require(!isInvalid);
        // Use the local variables to avoid the stack too deep error
        // bytes32 appCode = bytes32(0);
        for (uint256 i = 0; i < _modules.length; i++) {
            // (ITransferManager.Result valid, byte error, bytes32 reason) = ITransferManager(_modules[i]).transfer(_from, _to, _value, _data);
            ITransferManager.Result valid = ITransferManager(_modules[i]).transfer(_from, _to, _value, _data);
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

        if (isValid == true) {
            uint[] memory amounts = new uint[](2);
            amounts[0] = _balanceOf(_from).sub(_value);
            amounts[1] = _balanceOf(_to).add(_value);
            address[] memory holders = new address[](2);
            holders[0] = _from;
            holders[1] = _to;
            ITokenStore(tokenStore).setBalancesMulti(holders, amounts);
        }

        _isValidTransfer(isValid);
        // Balance overflow can never happen due to totalsupply being a uint256 as well
        // else if (!KindMath.checkAdd(balanceOf(_to), _value))
        //     return (0x50, bytes32(0));
        // return (status, appCode);
        // return (isValid, isValid ? bytes32(StatusCodes.code(StatusCodes.Status.TransferSuccess)): appCode);
    }
}
























