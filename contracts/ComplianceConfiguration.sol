pragma solidity >=0.4.21 <0.6.0;


contract ComplianceConfiguration{
    mapping(address=>string) configuations;
    function getConfiguration(address token) public view returns(string memory){
       return configuations[token];
    }
    function setConfiguration(address token, string memory configuation) public {
       configuations[token] = configuation;
    }
}
