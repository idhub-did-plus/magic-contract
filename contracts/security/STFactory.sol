pragma solidity 0.5.8;

import "./SecurityToken.sol";
import "./SecurityTokenLogic.sol";
import "./SecurityTokenStore.sol";

contract STFactory {
	bytes32 internal constant ISSUER = ; //keccak256(abi.encodePacked("ISSUER"))
	bytes32 internal constant PERMISSION_MANAGEMENT = ; //keccak256(abi.encodePacked("PERMISSION MANAGEMENT"))

	function depolyToken(
		string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _granularity
    ) external returns(address) {
		address store = _deployStore();
		address logic = _deployLogic();
		return _deployProxy(_name, _symbol, _decimals, _granularity, store, logic);
	}

	function _deployProxy(
		string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _granularity,
        address _store, 
        address _logic
    ) internal returns (address) {
		SecurityToken st = new SecurityToken(_store, _logic);
		SecurityTokenStore(_store).setPermission(address(st), msg.sender, address(st), ISSUER, true);
		SecurityTokenStore(_store).setPermission(address(st), msg.sender, address(st), PERMISSION_MANAGEMENT, true);
		SecurityTokenStore(_store).changeOwner(address(st));
		SecurityTokenStore(_store).setName(address(st), _name);
		SecurityTokenStore(_store).setSymbol(address(st), _symbol);
		SecurityTokenStore(_store).setDecimals(address(st), _decimals);
		SecurityTokenStore(_store).setGranularity(address(st), _granularity);
		return address(st);
	}

	function _deployLogic() internal returns(address) {
		SecurityTokenLogic logic = new SecurityTokenLogic();
		return logic;
	}

	function _deployStore() internal returns(address) {
		SecurityTokenStore store = new SecurityTokenStore();
		return store;
	}
}