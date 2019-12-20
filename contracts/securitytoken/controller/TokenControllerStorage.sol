pragma solidity 0.5.8;

contract TokenControllerStorage {
	address internal _owner;

	address[] public controllers;
	mapping(address => uint) public controllerIndexes;
}