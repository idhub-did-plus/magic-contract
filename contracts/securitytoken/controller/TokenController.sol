pragma solidity 0.5.8;

import "./TokenControllerStorage.sol";
import "../interfaces/ITokenStore.sol";
import "../interfaces/ISecurityToken.sol";
import "../libraries/SafeMath.sol";

contract TokenController is TokenControllerStorage {
    using SafeMath for uint;
    
    function _isAuthorized() internal view {
        require(msg.sender == _owner, "Unauthorized");
    }

    function _isNotInsufficient(address _from, uint _value) internal view {
        require(ISecurityToken(msg.sender).balanceOf(_from) >= _value, "Insufficient Balances");
    }

	// Controller Operation
    function isControllable(address _controller) external view returns (bool) {
    	controllerIndexes[_controller] != 0 ? true : false;
    }

    function controllerTransfer(address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external {
    	_isAuthorized();
    	_isNotInsufficient(_from, _value);
    	uint[] memory amounts = new uint[](2);
    	amounts[0] = ISecurityToken(msg.sender).balanceOf(_from).sub(_value);
    	amounts[1] = ISecurityToken(msg.sender).balanceOf(_to).add(_value);
        address[] memory holders = new address[](2);
        holders[0] = _from;
        holders[1] = _to;
        // ITokenStore(tokenStore).setBalancesMulti(holders, amounts);
    	ITokenStore(ISecurityToken(msg.sender).tokenStore()).setBalancesMulti(holders, amounts);
    }

    function controllerRedeem(address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external {
    	_isAuthorized();
    	ITokenStore(ISecurityToken(msg.sender).tokenStore()).setTotalSupply(ISecurityToken(msg.sender).totalSupply().sub(_value));
    	ITokenStore(ISecurityToken(msg.sender).tokenStore()).setBalances(_tokenHolder, ISecurityToken(msg.sender).balanceOf(_tokenHolder).sub(_value));
    }
}