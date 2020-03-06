pragma solidity 0.5.8;

import "./interfaces/IDataStore.sol";
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

contract SecurityTokenLogic is IERC20, IERC1410, IERC1594, IERC1643, IERC1644 {
    using SafeMath for uint256;

    address public tokenStore;

    // Document Events
    event DocumentRemoved(bytes32 indexed _name, string _uri, bytes32 _documentHash);
    event DocumentUpdated(bytes32 indexed _name, string _uri, bytes32 _documentHash);

    modifier checkGranularity(uint256 _value) {
        require(_value % granularity == 0, "Invalid granularity");
        _;
    }


    //////////////////////////
    /// Document Fuctions
    //////////////////////////

    function docNames() external view returns(bytes32[] memory) {
        return ITokenStore(tokenStore).getDocNames();
    }

    function getAllDocuments() external view returns (bytes32[] memory) {
        return ITokenStore(tokenStore).getDocNames();
    }

    function getDocument(bytes32 _name) external view returns (string memory, bytes32, uint256) {
        return ITokenStore(tokenStore).getDocument(_name);
    }

    /**
     * @notice Used to attach a new document to the contract, or update the URI or hash of an existing attached document
     * @dev Can only be executed by the owner of the contract.
     * @param _name Name of the document. It should be unique always
     * @param _uri Off-chain uri of the document from where it is accessible to investors/advisors to read.
     * @param _documentHash hash (of the contents) of the document.
     */
    function setDocument(bytes32 _name, string calldata _uri, bytes32 _documentHash) external {
        // _isAuthorized();
        require(_name != bytes32(0), "Bad name");
        require(bytes(_uri).length > 0, "Bad uri");
        ITokenStore(tokenStore).setDocument(_name, _uri, _documentHash);
        emit DocumentUpdated(name, uri, documentHash);
    }

    /**
     * @notice Used to remove an existing document from the contract by giving the name of the document.
     * @dev Can only be executed by the owner of the contract.
     * @param _name Name of the document. It should be unique always
     */
    function removeDocument(bytes32 _name) external {
        // _isAuthorized();
        ITokenStore(tokenStore).removeDocument(_name);
        (string memory uri, bytes32 docHash, ) = ITokenStore(tokenStore).getDocument(_name);
        emit DocumentRemoved(_name, uri, docHash);
    }


    /////////////////////////////
    // ERC20Interfaces
    /////////////////////////////

    function name() external view returns (string memory) {
        return ITokenStore(tokenStore).getName(address(this));
    }

    function symbol() external view returns (string memory) {
        return ITokenStore(tokenStore).getSymbol(address(this));
    }

    function decimals() external view returns (uint8) {
        return ITokenStore(tokenStore).getDecimals(address(this));
    }

    function totalSupply() external view returns (uint256) {
    	return ITokenStore(tokenStore).getTotalSupply(address(this));
    }

    function balanceOf(address account) external view returns (uint256) {
    	return ITokenStore(tokenStore).getBalances(address(this), account);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return ITokenStore(tokenStore).getAllowances(address(this), owner, spender);
    }

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool) {
        _transferWithData(address(this), msg.sender, msg.sender, recipient, amount, new bytes(0));
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
        ITokenStore(tokenStore).setAllowances(address(this), msg.sender, spender, amount);
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
        _transferWithData(address(this), msg.sender, sender, recipient, amount, new bytes(0));
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // 仅用于其它partition调用
    function baseTransfer(address partition, address caller, address sender, address recipient, uint256 amount, bytes calldata _data) external returns (bool) {
        // _isAuthorized(); 权限检查占位
        _transferWithData(partition, caller, sender, recipient, amount, _data);
        return true;
    }


    /////////////////////////////
    // Modules Fuctions
    /////////////////////////////

    function addModule(address _partition, address _module) external {
        // _isAuthorized(); 权限检查占位
        require(_module != address(0), "Invalid Module");
        require(_partition != address(0), "Invalid Module");
        ITokenStore(tokenStore).addModule(_partition, _module);
    }

    function removeModule(address _partition, address _module) external {
        // _isAuthorized(); 权限检查占位
        ITokenStore(tokenStore).removeModule(_partition, _module);
    }


    /////////////////////////////
    // ERC1594Interfaces
    /////////////////////////////

    // Transfer Validity
    function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        // return _canTransfer(modulesByType[TRANSFER_KEY], msg.sender, _to, _value, _data);
        return _canTransfer(address(this), msg.sender, msg.sender, _to, _value, _data);
    }

    function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        // return _canTransfer(modulesByType[TRANSFER_KEY], _from, _to, _value, _data);
        return _canTransfer(address(this), msg.sender, _from, _to, _value, _data);
    }

    // 仅用于其它partition调用
    function baseCanTransfer(address _partition, address _caller, address _sender, address _recipient, uint256 _amount, bytes calldata _data) external returns (bool) {
        // _isAuthorized(); 权限检查占位
        return _canTransfer(_partition, _caller, _sender, _recipient, _amount, _data);
    }

    // Transfers
    function transferWithData(address _to, uint256 _value, bytes calldata _data) external {
        _transferWithData(address(this), msg.sender, _to, _value, _data);
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFromWithData(address _from, address _to, uint256 _value, bytes calldata _data) external {
        _transferWithData(address(this), _from, _to, _value, _data);
        emit Transfer(_from, _to, _value);
    }

    // Token Issuance
    function isIssuable() external view returns (bool) {
        return _isIssuable();
    }

    function issue(address _tokenHolder, uint256 _value, bytes calldata _data) external checkGranularity(_value) {
        require(_isIssuable(), "Security Can Not Issue");
        ITokenStore(tokenStore).setBalances(_tokenHolder, _balanceOf(_tokenHolder).add(_value));
        ITokenStore(tokenStore).setTotalSupply(_totalSupply().add(_value));
        _adjustInvestorCount(address(0), _tokenHolder, _value, _balanceOf(_tokenHolder), 0);
    }

    // Token Redemption
    function redeem(uint256 _value, bytes calldata _data) external checkGranularity(_value) {
        ITokenStore(tokenStore).setBalances(msg.sender, _balanceOf(msg.sender).sub(_value));
        ITokenStore(tokenStore).setTotalSupply(_totalSupply().sub(_value));
        _adjustInvestorCount(msg.sender, address(0), _value, 0, _balanceOf(msg.sender));
    }

    function redeemFrom(address _tokenHolder, uint256 _value, bytes calldata _data) external checkGranularity(_value) {
        ITokenStore(tokenStore).setBalances(_tokenHolder, _balanceOf(_tokenHolder).sub(_value));
        ITokenStore(tokenStore).setTotalSupply(_totalSupply().sub(_value));
        _adjustInvestorCount(_tokenHolder, address(0), _value, 0, _balanceOf(_tokenHolder));
    }


    /////////////////////////////
    // ERC1644Interfaces 
    /////////////////////////////

    function isControllable() external view returns (bool) {
        tokenController.isControllable(msg.sender);
    }

    function controllerTransfer(address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external checkGranularity(_value) {
        tokenController.controllerTransfer(_from, _to, _value, _data, _operatorData);
        emit ControllerTransfer(msg.sender, _from, _to, _value, _data, _operatorData);
    }

    function controllerRedeem(address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external checkGranularity(_value) {
        tokenController.controllerRedeem(_tokenHolder, _value, _data, _operatorData);
        emit ControllerRedemption(msg.sender, _tokenHolder, _value, _data, _operatorData);
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
        checkGranularity(_value) 
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
        checkGranularity(_value) 
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
        checkGranularity(_value) 
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
    function issueByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data) external checkGranularity(_value) {
        tokenPartition.issueByPartition(_partition, _tokenHolder, _value, _data);
        emit IssuedByPartition(_partition, _tokenHolder, _value, _data);
    }

    function redeemByPartition(bytes32 _partition, uint256 _value, bytes calldata _data) external checkGranularity(_value) {
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
        checkGranularity(_value) 
    {
        require(tokenPartition.isOperator(msg.sender, _tokenHolder) || 
            tokenPartition.isOperatorForPartition(_partition, msg.sender, _tokenHolder), 
            "Invalid Operator");
        tokenPartition.operatorRedeemByPartition(_partition, _tokenHolder, _value, _data, _operatorData);
    }


    /////////////////////////////
    // Internal Functions 
    /////////////////////////////
    
    function _isIssuable() internal view returns (bool) {
        return issuable;
    }

    function _canTransfer(
        address _partition,
        address _caller,
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        internal 
        checkGranularity(_value)
    {
        ITokenStore(tokenStore).canTransfer(_partition, _caller, _from, _to, _value, _data);
    }

    function _transferWithData(
        address _partition,
        address _caller,
        address _from, 
        address _to, 
        uint256 _value, 
        bytes memory _data
    ) 
        internal 
        checkGranularity(_value)
    {
        ITokenStore(tokenStore).transferWithData(_partition, _caller, _from, _to, _value, _data);
    }

    function _adjustInvestorCount(
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
            holderCount = holderCount.add(1);
            if (!_isExistingInvestor(_to)) {
                IDataStore(address(tokenStore)).insertAddress(INVESTORSKEY, _to);
                //KYC data can not be present if added is false and hence we can set packed KYC as uint256(1) to set added as true
                IDataStore(address(tokenStore)).setUint256(_getKey(WHITELIST, _to), uint256(1));
            }
        }
        // Check whether sender is moving all of their tokens
        if (_value == _balanceFrom) {
            holderCount = holderCount.sub(1);
        }
        return;
    }

    function _isExistingInvestor(address _investor) internal view returns(bool) {
        uint256 data = IDataStore(address(tokenStore)).getUint256(_getKey(WHITELIST, _investor));
        //extracts `added` from packed `whitelistData`
        return uint8(data) == 0 ? false : true;
    }

    function _getKey(bytes32 _key1, address _key2) internal pure returns(bytes32) {
        return bytes32(keccak256(abi.encodePacked(_key1, _key2)));
    }
}
























