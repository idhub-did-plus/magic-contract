pragma solidity >=0.4.21 <0.6.0;
import "contracts/ComplianceService.sol";
import "contracts/ComplianceConfiguration.sol";
import "contracts/lib/Strings.sol";
import "contracts/EthereumClaimsRegistryInterface.sol";
contract ConfigurableComplianceService is ComplianceService{
    using Strings for string;
    ComplianceConfiguration config;
    EthereumClaimsRegistryInterface erc780;
    address trustedIssuer = address(0x9999999999999999999999);
    function checkCompliance(address token, address from, address to, uint amount) public view returns(bool){
        bool rst = checkReceiverOnly(token, to, amount);
        return rst;
    }
     function checkReceiverOnly(address token, address to, uint amount) public view returns(bool){
        string memory conf = config.getConfiguration(token);
        string[] memory conditions = conf.split("||");
        for(uint i = 0; i < conditions.length; i++){
            string memory condition = conditions[i];
            bool valid = checkAnd(to, amount, condition);
            if(valid)
                return valid;

        }
        return true;
    }
    function checkAnd( address to, uint amount, string memory condition) internal view returns(bool){
        string[] memory items = condition.split("&&");
      
        for(uint i = 0; i < items.length; i++){
            string memory item = items[i];
            bool rst = checkItem(to, item, amount);
            if(!rst)
                return false;
            

        }
        return true;
    }
    function checkItem( address to,  string memory item,uint amount) internal view returns(bool){
        if(item.indexOf("==") > 0)
            return  checkEqualItem(to, item, amount);
         if(item.indexOf("!=") > 0)
            return  checkNotEqualItem(to, item, amount);
        return false;
     }
     function checkEqualItem( address to,  string memory item,uint amount) internal view returns(bool){
         string[] memory kv = item.split("==");
         string memory key = kv[0];
         string memory value = kv[1];
         bytes32  myvalue = erc780.getClaim(trustedIssuer, to, key.toBytes32());
         if(myvalue == value.toBytes32())
            return true;
        return false;


     }
      function checkNotEqualItem( address to,  string memory item,uint amount) internal view returns(bool){
         string[] memory kv = item.split("!=");
         string memory key = kv[0];
         string memory value = kv[1];
         bytes32  myvalue = erc780.getClaim(trustedIssuer, to, key.toBytes32());
         if(myvalue != value.toBytes32())
            return true;
        return false;


     }
}
