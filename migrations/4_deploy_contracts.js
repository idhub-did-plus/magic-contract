const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const ConfigurableComplianceService = artifacts.require("ConfigurableComplianceService");
const ComplianceConfiguration = artifacts.require("ComplianceConfiguration");

const EthereumClaimsRegistry = artifacts.require("EthereumClaimsRegistry");
const IdentityRegistry = artifacts.require("IdentityRegistry");
const EthereumDIDRegistry = artifacts.require("EthereumDIDRegistry");
const ERC1056 = artifacts.require("ERC1056");

const Strings = artifacts.require("Strings");
const TutorialToken = artifacts.require("TutorialToken");
module.exports = function (deployer) {



  deployer.deploy(ConfigurableComplianceService,
    ComplianceConfiguration.address,
    EthereumClaimsRegistry.address,
    IdentityRegistry.address,
    ERC1056.address);
  deployer.deploy(Strings);
  deployer.link(Strings, ConfigurableComplianceService);

 


  deployer.deploy(ComplianceServiceRegistry);





  deployer.deploy(TutorialToken);



}
