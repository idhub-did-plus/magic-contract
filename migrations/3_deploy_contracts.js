const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const ConfigurableComplianceService = artifacts.require("ConfigurableComplianceService");
const ComplianceConfiguration = artifacts.require("ComplianceConfiguration");

const EthereumClaimsRegistry = artifacts.require("EthereumClaimsRegistry");
const IdentityRegistry = artifacts.require("IdentityRegistry");
const EthereumDIDRegistry = artifacts.require("ComplianceConfiguration");
const ERC1056 = artifacts.require("ERC1056");

const Strings = artifacts.require("Strings");
const TutorialToken = artifacts.require("TutorialToken");
module.exports = function (deployer) {

  deployer.deploy(ERC1056, IdentityRegistry.address, EthereumDIDRegistry.address);
  deployer.deploy(ComplianceConfiguration);
  deployer.deploy(EthereumClaimsRegistry);


}
