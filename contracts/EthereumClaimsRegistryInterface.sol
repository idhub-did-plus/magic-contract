pragma solidity >=0.4.21 <0.6.0;

contract EthereumClaimsRegistryInterface {


    // create or update clams
    function setClaim(address subject, bytes32 key, bytes32 value) external;
    function setSelfClaim(bytes32 key, bytes32 value) external;
    function getClaim(address issuer, address subject, bytes32 key) external view returns(bytes32);

    function removeClaim(address issuer, address subject, bytes32 key) external;
}