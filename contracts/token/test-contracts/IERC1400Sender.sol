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
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}
