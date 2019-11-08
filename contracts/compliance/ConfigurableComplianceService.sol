pragma solidity >=0.4.21 <0.6.0;

import "./ComplianceService.sol";
import "./ComplianceConfiguration.sol";
import "./libs/Strings.sol";
import "../ownable/Ownable.sol";
import "../interfaces/EthereumClaimsRegistryInterface.sol";
import "../interfaces/IdentityRegistryInterface.sol";
import "../interfaces/EthereumDIDRegistryResolverInterface.sol";

contract ConfigurableComplianceService is ComplianceService, Ownable {
    using Strings for string;
    
    ComplianceConfiguration public config;
    EthereumClaimsRegistryInterface public erc780;
    IdentityRegistryInterface public erc1484;
    EthereumDIDRegistryResolverInterface public erc1056;
    address public trustedIssuer;
    
    constructor(address _config, address _erc780, address _erc1484, address _erc1056) public {
        config = ComplianceConfiguration(_config);
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
        string memory conf = config.getConfiguration(token);
        string[] memory conditions = conf.split("||");
        
        for(uint i = 0; i < conditions.length; i++){
            string memory condition = conditions[i];
            bool valid = checkAnd(checkedAddress, condition);
            if(valid)
                return valid;
        }
        
        return false;
    }
    
    function checkAnd(address checkedAddress, string memory condition) internal view returns (bool) {
        string[] memory items = condition.split("&&");
      
        for(uint i = 0; i < items.length; i++){
            string memory item = items[i];
            bool rst = checkItem(checkedAddress, item);
            if(!rst)
                return false;
        }
        return true;
    }
    
    function checkItem(address checkedAddress,  string memory item) internal view returns (bool) {
        if(item.indexOf("==") > 0)
            return checkEqualItem(checkedAddress, item);
        if(item.indexOf("!=") > 0)
            return checkNotEqualItem(checkedAddress, item);
        return false;
    }
     
    function checkEqualItem(address checkedAddress,  string memory item) internal view returns (bool) {
        string[] memory kv = item.split("==");
        string memory key = kv[0];
        string memory value = kv[1];
        bytes32 myvalue = erc780.getClaim(trustedIssuer, checkedAddress, keccak256(bytes(key)));
        if(myvalue == keccak256(bytes(value)))
            return true;
        return false;


    }
     
    function checkNotEqualItem(address checkedAddress,  string memory item) internal view returns (bool) {
        string[] memory kv = item.split("!=");
        string memory key = kv[0];
        string memory value = kv[1];
        bytes32  myvalue = erc780.getClaim(trustedIssuer, checkedAddress, keccak256(bytes(key)));
        if(myvalue != keccak256(bytes(value)))
            return true;
        return false;
    }
}
