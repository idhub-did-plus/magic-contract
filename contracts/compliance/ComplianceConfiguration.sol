pragma solidity >=0.4.21 <0.6.0;

import "./ownable/Ownable.sol";

contract ComplianceConfiguration is Ownable{
    mapping(address=>string) configuations;
    
    function getConfiguration(address token) public view returns (string) {
        return configuations[token];
    }
    
    function setConfiguration(address token, string memory configuation) public onlyOwner {
        configuations[token] = configuation;
    }
}
