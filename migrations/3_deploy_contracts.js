
const ComplianceConfiguration = artifacts.require("ComplianceConfiguration");

const EthereumClaimsRegistry = artifacts.require("EthereumClaimsRegistry");
const IdentityRegistry = artifacts.require("IdentityRegistry");
const EthereumDIDRegistry = artifacts.require("EthereumDIDRegistry");
const ERC1056 = artifacts.require("ERC1056");


module.exports = function (deployer) {
  deployer.deploy(ERC1056, IdentityRegistry.address, EthereumDIDRegistry.address);
  deployer.deploy(ComplianceConfiguration);
  deployer.deploy(EthereumClaimsRegistry);
}
