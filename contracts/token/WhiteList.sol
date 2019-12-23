pragma solidity ^0.5.0;


contract whistlist {
    
   // Mapping from (tokenHolder) to whitelist status.
   mapping (address => bool) internal _whitelist;
   //Owner
   address private owner;
   
    constructor()public{
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    } 
    
  /**
   * @dev Get whitelist status for a tokenHolder.
   * @param tokenHolder Address whom to check the whitelisted status for.
   * @return bool 'true' if tokenHolder is whitelisted, 'false' if not.
   */
   function getwhitelist(address tokenHolder) external view returns (bool) {
        return _whitelist[tokenHolder];
   }

  /**
   * @dev Set whitelist status for a tokenHolder.
   * @param tokenHolder Address to add/remove from whitelist.
   * @param authorized 'true' if tokenHolder shall be added to whitelist, 'false' if not.
   */
   function setWhitelist(address tokenHolder, bool authorized) external onlyOwner {
        _setWhitelist(tokenHolder, authorized);
    }
  /**
   * @dev Set whitelisted status for a tokenHolder.
   * @param tokenHolder Address to add/remove from whitelist.
   * @param authorized 'true' if tokenHolder shall be added to whitelist, 'false' if not.
   */
   function _setWhitelist(address tokenHolder, bool authorized) internal {
        require(tokenHolder != address(0)); // Action Blocked - Not a valid address
        _whitelist[tokenHolder] = authorized;
    }

}
