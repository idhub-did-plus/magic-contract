pragma solidity 0.5.8;

import "./IDataStore.sol";

interface ITokenStore {
    // data getter
    function getName() external view returns(string memory);

    function getSymbol() external view returns(string memory);

    function getDecimals() external view returns(uint8);

    function getTotalSupply() external view returns(uint);

    function getBalances(address _holder) external view returns(uint);

    function getAllowances(address _from, address _to) external view returns(uint);

    // data setter
    function setName(string calldata _name) external;

    function setSymbol(string calldata _symbol) external;

    function setDecimals(uint8 _decimals) external;

    function setTotalSupply(uint _totalSupply) external;

    function setBalances(address _holder, uint _amount) external;

    function setAllowances(address _from, address _to, uint _amount) external;

    // mutil data setter
    function setBalancesMulti(address[] calldata _holders, uint[] calldata _amounts) external;

    function setAllowancesMulti(address[] calldata _from, address[] calldata _to, uint[] calldata _amounts) external;
}

