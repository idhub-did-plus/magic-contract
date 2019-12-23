pragma solidity 0.5.8;

import "../datastore/DataStore.sol";

contract TokenStorage is DataStore {
	address public securityToken;

	// ERC20 Details
    string internal name;
    string internal symbol;
    uint8 internal decimals;
    uint internal totalSupply;
    mapping(address => uint) internal balances;
    mapping (address => mapping (address => uint256)) internal allowances;
}

