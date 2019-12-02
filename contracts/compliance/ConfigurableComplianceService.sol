pragma solidity ^0.5.0;

import "./ComplianceService.sol";
import "./ComplianceConfiguration.sol";
import "./libs/Strings.sol";
import "./ownable/Ownable.sol";
import "./interfaces/EthereumClaimsRegistryInterface.sol";
import "./interfaces/IdentityRegistryInterface.sol";
import "./interfaces/EthereumDIDRegistryResolverInterface.sol";

contract ConfigurableComplianceService is ComplianceConfiguration, ComplianceService {
    using Strings for *;
    
    // ComplianceConfiguration public config;
    EthereumClaimsRegistryInterface public erc780;
    IdentityRegistryInterface public erc1484;
    EthereumDIDRegistryResolverInterface public erc1056;
    address public trustedIssuer;
    
    constructor (address _erc780, address _erc1484, address _erc1056) public {
        // config = ComplianceConfiguration(_config);
        erc780 = EthereumClaimsRegistryInterface(_erc780);
        erc1484 = IdentityRegistryInterface(_erc1484);
        erc1056 = EthereumDIDRegistryResolverInterface(_erc1056);
    }
    
    function setTrustedIssuer(address newIssuer) public onlyOwner {
        trustedIssuer = newIssuer;
    }
    
    function getTrustedIssuer() public view returns (address) {
        return trustedIssuer;
    }
    
    function checkCompliance(address token, address from, address to) public view returns (bool) {
        bool rstSender = checkSenderOnly(token, from);
        bool rstReceiver = checkReceiverOnly(token, to);
        return rstSender && rstReceiver;
    }
    
    function checkSenderOnly(address token, address from) public view returns (bool) {
        uint ein = erc1484.getEIN(from);
        address did = erc1056.einToDID(ein); 
        bool rst = checkOr(token, did);
        return rst;
    }
    
    function checkReceiverOnly(address token, address to) public view returns (bool) {
        uint ein = erc1484.getEIN(to);
        address did = erc1056.einToDID(ein); 
        bool rst = checkOr(token, did);
        return rst;
    }
    
    function checkOr(address token, address checkedAddress) public view returns (bool) {
        Strings.slice memory conf = getConfiguration(token).toSlice();
        Strings.slice memory delim = "||".toSlice();
        string[] memory conditions = new string[](conf.count(delim) + 1);
        for(uint i = 0; i < conditions.length; i++) {
            conditions[i] = conf.split(delim).toString();
            string memory condition = conditions[i];
            bool valid = checkAnd(checkedAddress, condition);
            if(valid)
                return valid;
        }
        return false;
    }
    
    function checkAnd(address checkedAddress, string memory condition) public view returns (bool) {
        Strings.slice memory s = condition.toSlice();
         Strings.slice memory delim = "&&".toSlice();
        string[] memory parts = new string[](s.count(delim) + 1);
        for(uint i = 0; i < parts.length; i++) {
            parts[i] = s.split(delim).toString();
            bool rst = checkItem(checkedAddress, parts[i]);
            if(!rst)
                return false;
        }
        return true;
    }
    
    function checkItem(address checkedAddress,  string memory item) public view returns (bool) {
        if(item.toSlice().contains("==".toSlice()))
            return checkEqualItem(checkedAddress, item);
        if(item.toSlice().contains("!=".toSlice()))
            return checkNotEqualItem(checkedAddress, item);
        return false;
    }
     
    function checkEqualItem(address checkedAddress,  string memory item) public view returns (bool) {
        Strings.slice memory kv = item.toSlice();
        string memory key = kv.split("==".toSlice()).toString();
        string memory value = kv.toString();
        bytes32 myvalue = erc780.getClaim(trustedIssuer, checkedAddress, keccak256(bytes(key)));
        if(myvalue == keccak256(bytes(value)))
            return true;
        return false;
    }
     
    function checkNotEqualItem(address checkedAddress,  string memory item) public view returns (bool) {
         Strings.slice memory kv = item.toSlice();
        string memory key = kv.split("!=".toSlice()).toString();
        string memory value = kv.toString();
        bytes32  myvalue = erc780.getClaim(trustedIssuer, checkedAddress, keccak256(bytes(key)));
        if(myvalue != keccak256(bytes(value)))
            return true;
        return false;
    }
}
