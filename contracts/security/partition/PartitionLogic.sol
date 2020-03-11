pragma solidity 0.5.8;

import "./interfaces/ITokenStore.sol";
import "./interfaces/ISecurityToken.sol";
import "./interfaces/tokens/IERC20.sol";

contract SecurityTokenLogic is IERC20, IERC1410, IERC1594, IERC1643, IERC1644 {
    using SafeMath for uint256;

    address public securityToken;
    address public tokenStore;

    /////////////////////////////
    // ERC20Interfaces
    /////////////////////////////

    function name() external view returns (string memory) {
        return ITokenStore(tokenStore).getName(address(this));
    }

    function symbol() external view returns (string memory) {
        return ITokenStore(tokenStore).getSymbol(address(this));
    }

    function decimals() external view returns (uint8) {
        return ITokenStore(tokenStore).getDecimals(address(this));
    }

    function totalSupply() external view returns (uint256) {
    	return ITokenStore(tokenStore).getTotalSupply(address(this));
    }

    function balanceOf(address account) external view returns (uint256) {
    	return ITokenStore(tokenStore).getBalances(address(this), account);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return ITokenStore(tokenStore).getAllowances(address(this), owner, spender);
    }

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool) {
        ISecurityToken(securityToken).baseTransfer(address(this), msg.sender, msg.sender, recipient, amount, new bytes(0));
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        ISecurityToken(securityToken).baseApprove(address(this), msg.sender, spender, amount);
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        ISecurityToken(securityToken).baseTransfer(address(this), msg.sender, sender, recipient, amount, new bytes(0));
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
























