pragma solidity 0.5.8;

import "./proxy/UpgradeabilityProxy.sol";
// import "./UpgradeabilityProxy.sol";
import "./SecurityTokenStorage.sol";

/**
 * @title SecurityTokenProxy SecurityToken
 */
contract SecurityToken is SecurityTokenStorage, UpgradeabilityProxy {

    /**
    * @notice Constructor
    * @param _implementation representing the address of the new implementation to be set
    */
    constructor(
        address _implementation,
        address _tokenStore, 
        address _tokenDocument, 
        address _tokenPartition
    )
        public
    {
        require(_implementation != address(0), "Address should not be 0x");
        // securityToken = ISecurityToken(_securityToken);
        __implementation = _implementation;
        tokenStore = ITokenStore(_tokenStore);
        tokenDocument = ITokenDocument(_tokenDocument);
        tokenPartition = ITokenPartition(_tokenPartition);
    }

    /**
    * @notice Internal function to provide the address of the implementation contract
    */
    function _implementation() internal view returns(address) {
        return __implementation;
    }

}
