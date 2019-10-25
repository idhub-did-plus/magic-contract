pragma solidity ^0.5.0;

contract ERC1056ResolverInterface {


    function initialize(address identity, uint8 v, bytes32 r, bytes32 s) external;

    function changeOwner(address newOwner) external;

    function changeOwnerDelegated(address approvingAddress, address newOwner, uint8 v, bytes32 r, bytes32 s) external ;

    function addDelegate(bytes32 delegateType, address delegate, uint validity)external;
    function addDelegateDelegated(
        address approvingAddress, bytes32 delegateType, address delegate, uint validity, uint8 v, bytes32 r, bytes32 s
    )external;

  

    function revokeDelegate(bytes32 delegateType, address delegate)external;

    function revokeDelegateDelegated(
        address approvingAddress, bytes32 delegateType, address delegate, uint8 v, bytes32 r, bytes32 s
    )external;

  
    function setAttribute(bytes32 name, bytes calldata value, uint validity) external;

    function setAttributeDelegated(
        address approvingAddress, bytes32 name, bytes calldata value, uint validity, uint8 v, bytes32 r, bytes32 s
    )external;



    function revokeAttribute(bytes32 name, bytes calldata value)external;

    function revokeAttributeDelegated(
        address approvingAddress, bytes32 name, bytes calldata value, uint8 v, bytes32 r, bytes32 s
    )external;


}
