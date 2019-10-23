pragma solidity >=0.4.21 <0.6.0;

import "contracts/ComplianceServiceRegistry.sol";

contract Main{
     constructor() public {
        ComplianceServiceRegistry c = new ComplianceServiceRegistry();
        c.findService(address(0));
    }
}
