pragma solidity 0.5.8;

import "./TokenStorage.sol";

contract TokenStore is TokenStorage {
    function _isAuthorized() internal view {
        require(msg.sender == _owner, "Unauthorized");
    }
    // data getter
    function getName() external view returns(string memory) {
        return name;
    }

    function getSymbol() external view returns(string memory) {
        return symbol;
    }

    function getDecimals() external view returns(uint8) {
        return decimals;
    }

    function getTotalSupply() external view returns(uint) {
        return totalSupply;
    }

    function getBalances(address _holder) external view returns(uint) {
        return balances[_holder];
    }

    function getAllowances(address _from, address _to) external view returns(uint) {
        return allowances[_from][_to];
    }

    // data setter
    function setName(string calldata _name) external {
        _isAuthorized();
        name = _name;
    }

    function setSymbol(string calldata _symbol) external {
        _isAuthorized();
        symbol = _symbol;
    }

    function setDecimals(uint8 _decimals) external {
        _isAuthorized();
        decimals = _decimals;
    }

    function setTotalSupply(uint _totalSupply) external {
        _isAuthorized();
        totalSupply = _totalSupply;
    }

    function setBalances(address _holder, uint _amount) external {
        _isAuthorized();
        balances[_holder] = _amount;
    }

    function setAllowances(address _from, address _to, uint _amount) external {
        _isAuthorized();
        allowances[_from][_to] = _amount;
    }

    // mutil data setter
    function setBalancesMulti(address[] calldata _holders, uint[] calldata _amounts) external {
        _isAuthorized();
        for (uint256 i = 0; i < _holders.length; i++) {
            balances[_holders[i]] = _amounts[i];
        }
    }

    function setAllowancesMulti(address[] calldata _from, address[] calldata _to, uint[] calldata _amounts) external {
        _isAuthorized();
        for (uint256 i = 0; i < _from.length; i++) {
            allowances[_from[i]][_to[i]] = _amounts[i];
        }
    }
}

