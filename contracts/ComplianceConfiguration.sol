pragma solidity >=0.4.21 <0.6.0;


contract ComplianceConfiguration{
   address owner;
       constructor() public{
        owner = msg.sender;
    }
    mapping(address=>string) configuations;
    function getConfiguration(address token) public view returns(string memory){
       return configuations[token];
    }
    function setConfiguration(address token, string memory configuation) public {
       require(msg.sender == owner, "only owner is valid!");
       configuations[token] = configuation;
    }
}
