pragma solidity >=0.4.21 <0.6.0;

contract ComplianceService {
    function checkCompliance(address token, address from, address to, uint amount)external view  returns(bool);
}
