pragma solidity ^0.5.0;

contract ComplianceServiceRegistry {
    mapping (address=> address) services;
    address defaultService;
    address owner;
    
     constructor() public {
        owner = msg.sender;
    }
    
    function register(address token, address service) public {
        require(msg.sender == owner);
        services[token] = service;
    }
    
    function setDefaultService(address service) public {
        require(msg.sender == owner);
        defaultService = service;
    }
    
    function getDefaultService() public view returns (address){
        return defaultService;
    }
    
    function findService(address token) public view returns (address){
        address rst = services[token];
        if(rst == address(0))
            return defaultService;
        return rst;
    }
}
