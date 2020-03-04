pragma solidity 0.5.8;

interface ITokenController {
	// Controller Operation
    function isControllable(address _controller) external view returns (bool);

    function controllerTransfer(address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external;

    function controllerRedeem(address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external;
}