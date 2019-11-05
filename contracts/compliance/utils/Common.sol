pragma solidity >=0.4.21 <0.6.0;
pragma experimental ABIEncoderV2;

import "../libs/Strings.sol";
import "../libs/TestAddresses.sol";

contract Common {
    using Strings for *;
    
    function commonKeccak256(string memory s) public view returns (bytes32) {
    	return keccak256(bytes(s));
    }
    
    function commonSplit(string memory base, string memory value) public view returns (string, string) {
        var s = base.toSlice();
        var foo = s.split(value.toSlice()).toString();
        return (s.toString(), foo);
    }
    
    function commonSplitArray(string memory param) public view returns (string[]) {
        var s = param.toSlice();
        var delim = "&&".toSlice();
        var parts = new string[](s.count(delim) + 1);
        for(uint i = 0; i < parts.length; i++) {
            parts[i] = s.split(delim).toString();
        }
        return parts;
    }

    function commonIsContract(address _contract) public view returns (bool) {
        return Addresses.isContract(_contract);
    }
}
