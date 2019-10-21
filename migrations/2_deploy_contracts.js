const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const TutorialToken = artifacts.require("TutorialToken");
const ConfiguableComplianceService = artifacts.require("ConfiguableComplianceService");

module.exports = function(deployer) {
  deployer.deploy(ComplianceServiceRegistry);
  deployer.deploy(ConfiguableComplianceService);
  deployer.deploy(TutorialToken);
};
