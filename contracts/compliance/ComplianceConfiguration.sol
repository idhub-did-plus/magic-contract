pragma solidity >=0.4.21 <0.6.0;

contract ComplianceConfiguration{
    address owner;
    mapping(address=>string) configuations;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function getConfiguration(address token) public view returns (string memory) {
        return configuations[token];
    }
    
    function setConfiguration(address token, string memory configuation) public {
        require(msg.sender == owner, "only owner is valid!");
        configuations[token] = configuation;
    }
}
