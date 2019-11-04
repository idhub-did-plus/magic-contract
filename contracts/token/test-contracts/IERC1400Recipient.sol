pragma solidity ^0.5.0;

/**
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC1400Recipient {
    /**
     *
     * This call occurs _after_ the token contract's state is updated
     * This function may revert to prevent the operation from being executed.
     */
    function tokensReceived(
        address _operator,
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _userData,
        bytes calldata _operatorData
    ) external;
}