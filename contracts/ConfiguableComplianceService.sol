pragma solidity >=0.4.21 <0.6.0;
import "contracts/ComplianceService.sol";

contract ConfiguableComplianceService is ComplianceService{
    function checkCompliance(address token, address from, address to, uint amount) public returns(bool){

        return true;
    }
}
