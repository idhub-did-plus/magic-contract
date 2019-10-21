const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const TutorialToken = artifacts.require("TutorialToken");
const ConfigurableComplianceService = artifacts.require("ConfigurableComplianceService");

module.exports = function(deployer) {
  deployer.deploy(ComplianceServiceRegistry);
  deployer.deploy(ConfigurableComplianceService);
  deployer.deploy(TutorialToken);
};
