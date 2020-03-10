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

    address internal constant ALL_PARTITION = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    bytes32 internal constant PARTITION = ; //keccak256(abi.encodePacked("PARTITION"))
    bytes32 internal constant OPERATOR = ; //keccak256(abi.encodePacked("OPERATOR"))
    bytes32 internal constant CONTROLLER = ; //keccak256(abi.encodePacked("CONTROLLER"))
    bytes32 internal constant DOCUMENT_MANAGEMENT = ; //keccak256(abi.encodePacked("DOCUMENT MANAGEMENT"))
    bytes32 internal constant MODULE_MANAGEMENT = ; //keccak256(abi.encodePacked("MODULE MANAGEMENT"))
    bytes32 internal constant PERMISSION_MANAGEMENT = ; //keccak256(abi.encodePacked("PERMISSION MANAGEMENT"))

    address public tokenStore;

    modifier checkGranularity(uint256 _value) {
        require(_value % granularity == 0, "Invalid granularity");
        _;
    }

    function checkPermission(address _partition, address _from, address _to, bytes32 _perm) external view returns(bool) {
        return _checkPermission(_partition, _from, _to, _perm);
    }

    function changePermission(address _partition, address _from, address _to, bytes32 _perm, bytes32 _value) external view returns(bool) {
        require(_checkPermission(address(this), msg.sender, address(this), PERMISSION_MANAGEMENT), "Permission Error.");
        return _changePermission(_partition, _from, _to, _perm, _value);
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
        require(_checkPermission(address(this), msg.sender, address(this), DOCUMENT_MANAGEMENT), "Permission Error");
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
        require(_checkPermission(address(this), msg.sender, address(this), DOCUMENT_MANAGEMENT), "Permission Error");
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
        // ITokenStore(tokenStore).setAllowances(address(this), msg.sender, spender, amount);
        _approve(address(this), msg.sender, spender, amount);
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
        require(_checkPermission(address(this), msg.sender, address(this), PARTITION), "Must called by partition contract.");
        _transferWithData(partition, caller, sender, recipient, amount, _data);
        return true;
    }

    // 仅用于其它partition调用
    function baseApprove(address partition, address sender, address recipient, uint256 amount) external returns (bool) {
        require(_checkPermission(address(this), msg.sender, address(this), PARTITION), "Must called by partition contract.");
        _approve(partition, sender, recipient, amount);
        return true;
    }


    /////////////////////////////
    // Modules Fuctions
    /////////////////////////////

    function addModule(address _partition, address _module) external {
        require(_checkPermission(address(this), msg.sender, address(this), MODULE_MANAGEMENT), "Permission Error");
        require(_module != address(0), "Invalid Module");
        require(_partition != address(0), "Invalid Module");
        ITokenStore(tokenStore).addModule(_partition, _module);
    }

    function removeModule(address _partition, address _module) external {
        require(_checkPermission(address(this), msg.sender, address(this), MODULE_MANAGEMENT), "Permission Error");
        ITokenStore(tokenStore).removeModule(_partition, _module);
    }


    /////////////////////////////
    // ERC1594Interfaces
    /////////////////////////////

    // Transfer Validity
    function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        return _canTransfer(address(this), msg.sender, msg.sender, _to, _value, _data);
    }

    function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        return _canTransfer(address(this), msg.sender, _from, _to, _value, _data);
    }

    // 仅用于其它partition调用
    function baseCanTransfer(address _partition, address _caller, address _sender, address _recipient, uint256 _amount, bytes calldata _data) external returns (bool) {
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
        return _checkPermission(address(this), msg.sender, address(this), CONTROLLER);
    }

    function controllerTransfer(address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external checkGranularity(_value) {
        require(_checkPermission(address(this), msg.sender, address(this), CONTROLLER), "Caller is not controller.");
        _transferWithData(address(this), _from, _from, _to, _value, new bytes(0));
        emit ControllerTransfer(msg.sender, _from, _to, _value, _data, _operatorData);
    }

    function controllerRedeem(address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external checkGranularity(_value) {
        require(_checkPermission(address(this), msg.sender, address(this), CONTROLLER), "Caller is not controller.");
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
        ITokenStore(tokenStore).balanceOfByPartition(_partition, _tokenHolder);
    }

    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory) {
        ITokenStore(tokenStore).partitionsOf(_tokenHolder);
    }

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
        address partitionAddress = ITokenStore(tokenStore).getPartitionAddress(_partition);
        _transferWithData(_partition, msg.sender, msg.sender, _to, _value, new bytes(0));
        /*uint[] memory amounts = new uint[](2);
        amounts[0] = ITokenStore(tokenStore).getBalances(partitionAddress, msg.sender).sub(_value);
        amounts[1] = ITokenStore(tokenStore).getBalances(partitionAddress, _to).add(_value);
        address[] memory holders = new address[](2);
        holders[0] = msg.sender;
        holders[1] = _to;
        ITokenStore(tokenStore).setBalancesMulti(partitionAddress, holders, amounts);*/
        emit TransferByPartition(_partition, msg.sender, msg.sender, _to, _value, _data, new bytes(0));
        return _partition;
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
        require(_checkPermission(_partition, msg.sender, _from, OPERATOR) || 
            _checkPermission(ALL_PARTITION, msg.sender, _from, OPERATOR), 
            "Permission Error");
        address partitionAddress = ITokenStore(tokenStore).getPartitionAddress(_partition);
        _transferWithData(_partition, _from, _from, _to, _value, new bytes(0));
        emit TransferByPartition(_partition, msg.sender, _from, _to, _value, _data, _operatorData);
        return _partition;
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
        address partitionAddress = ITokenStore(tokenStore).getPartitionAddress(_partition);
        return _canTransfer(partitionAddress, _from, _from, _to, _value, _data);
    }

    // Operator Information
    // These functions are present in the STGetter
    function isOperator(address _operator, address _tokenHolder) external view returns (bool) {
        return _checkPermission(ALL_PARTITION, _operator, _tokenHolder, OPERATOR);
    }

    function isOperatorForPartition(bytes32 _partition, address _operator, address _tokenHolder) external view returns (bool) {
        address partitionAddress = ITokenStore(tokenStore).getPartitionAddress(_partition);
        return _checkPermission(partitionAddress, _operator, _tokenHolder, OPERATOR);
    }

    // Operator Management
    function authorizeOperator(address _operator) external {
        IDataStore(tokenStore).setPermission(ALL_PARTITION, _operator, msg.sender, OPERATOR, true);
        emit AuthorizedOperator(_operator, msg.sender);
    }

    function revokeOperator(address _operator) external {
        IDataStore(tokenStore).setPermission(ALL_PARTITION, _operator, msg.sender, OPERATOR, false);
        emit RevokedOperator(_operator, msg.sender);
    }

    function authorizeOperatorByPartition(bytes32 _partition, address _operator) external {
        IDataStore(tokenStore).setPermission(_partition, _operator, msg.sender, OPERATOR, true);
        emit AuthorizedOperatorByPartition(_partition, _operator, msg.sender);
    }

    function revokeOperatorByPartition(bytes32 _partition, address _operator) external {
        IDataStore(tokenStore).setPermission(_partition, _operator, msg.sender, OPERATOR, false);
        emit RevokedOperatorByPartition(_partition, _operator, msg.sender);
    }

    // Issuance / Redemption
    function issueByPartition(bytes32 _partition, address _tokenHolder, uint256 _value, bytes calldata _data) external checkGranularity(_value) {
        emit IssuedByPartition(_partition, _tokenHolder, _value, _data);
    }

    function redeemByPartition(bytes32 _partition, uint256 _value, bytes calldata _data) external checkGranularity(_value) {
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

    function _approve(
        address _partition,
        address _from, 
        address _to, 
        uint256 _value
    ) 
        internal 
        checkGranularity(_value)
    {
        ITokenStore(tokenStore).setAllowances(_partition, _from, _to, _value);
    }

    function _checkPermission(address _partition, address _from, address _to, bytes32 _perm) internal view returns(bool) {
        return ITokenStore(tokenStore).getPermission(_partition, _from, _to, _perm);
    }

    function _changePermission(address _partition, address _from, address _to, bytes32 _perm, bool _value) internal view returns(bool) {
        return ITokenStore(tokenStore).setPermission(_partition, _from, _to, _perm, _value);
    }
}
























