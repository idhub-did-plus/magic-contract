pragma solidity ^0.5.0;

import "./ERC777.sol";

contract IDHub is ERC777 {
    constructor(
        address[] memory defaultOperators
    )
        ERC777("IDHub", "IDH", defaultOperators)
        public
    {
        uint initialSupply = 5 * 10 ** 9 * 10 ** 18;
        _mint(msg.sender, msg.sender, initialSupply, "", "");
    }
}
