pragma solidity 0.5.8;

import "./SecurityTokenStorage.sol";
import "./datastore/DataStore.sol";

contract SecurityTokenStore is SecurityTokenStorage, DataStore  {
    function _isAuthorized() internal view {
        require(msg.sender == _owner, "Unauthorized");
    }
    // data getter
    function getName(address _partition) external view returns(string memory) {
        return names[_partition];
    }

    function getSymbol(address _partition) external view returns(string memory) {
        return symbols[_partition];
    }

    function getDecimals(address _partition) external view returns(uint8) {
        return decimals[_partition];
    }

    function getTotalSupply(address _partition) external view returns(uint) {
        return totalSupplys[_partition];
    }

    function getBalances(address _partition, address _holder) external view returns(uint) {
        return balances[_partition][_holder];
    }

    function getAllowances(address _partition, address _from, address _to) external view returns(uint) {
        return allowances[_partition][_from][_to];
    }

    // data setter
    function setName(address _partition, string calldata _name) external {
        _isAuthorized();
        names[_partition] = _name;
    }

    function setSymbol(address _partition, string calldata _symbol) external {
        _isAuthorized();
        symbols[_partition] = _symbol;
    }

    function setDecimals(address _partition, uint8 _decimals) external {
        _isAuthorized();
        decimals[_partition] = _decimals;
    }

    function setTotalSupply(address _partition, uint _totalSupply) external {
        _isAuthorized();
        totalSupplys[_partition] = _totalSupply;
    }

    function setBalances(address _partition, address _holder, uint _amount) external {
        _isAuthorized();
        balances[_partition][_holder] = _amount;
    }

    function setAllowances(address _partition, address _from, address _to, uint _amount) external {
        _isAuthorized();
        allowances[_partition][_from][_to] = _amount;
    }

    // mutil data setter
    function setBalancesMulti(address _partition, address[] calldata _holders, uint[] calldata _amounts) external {
        _isAuthorized();
        for (uint256 i = 0; i < _holders.length; i++) {
            balances[_partition][_holders[i]] = _amounts[i];
        }
    }

    function setAllowancesMulti(address _partition, address[] calldata _from, address[] calldata _to, uint[] calldata _amounts) external {
        _isAuthorized();
        for (uint256 i = 0; i < _from.length; i++) {
            allowances[_partition][_from[i]][_to[i]] = _amounts[i];
        }
    }
}

