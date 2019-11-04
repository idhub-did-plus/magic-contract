pragma solidity ^0.5.0;

/**
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC1400Sender {
    /**
     * @dev This call occurs _before_ the token contract's state is updated
     * This function may revert to prevent the operation from being executed.
     */
    function tokensToSend(
        address _operator,
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _userData,
        bytes calldata _operatorData
    ) external;
}
