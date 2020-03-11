pragma solidity 0.5.8;

import "./proxy/OwnedUpgradeabilityProxy.sol";
// import "./UpgradeabilityProxy.sol";
import "./SecurityTokenStorage.sol";

/**
 * @title SecurityTokenProxy SecurityToken
 */
contract SecurityToken is SecurityTokenStore, OwnedUpgradeabilityProxy {

    address public tokenStore;

    /**
    * @notice Constructor
    * @param _implementation representing the address of the new implementation to be set
    */
    constructor(address _store, address _implementation) public {
        require(_implementation != address(0), "Address should not be 0x");
        require(_store != address(0), "Address should not be 0x");
        // securityToken = ISecurityToken(_securityToken);
        __implementation = _implementation;
        tokenStore = _store;
    }

    /**
    * @notice Internal function to provide the address of the implementation contract
    */
    function _implementation() internal view returns(address) {
        return __implementation;
    }

}
