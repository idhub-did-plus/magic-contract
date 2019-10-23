const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const ConfigurableComplianceService = artifacts.require("ConfigurableComplianceService");
const ComplianceConfiguration = artifacts.require("ComplianceConfiguration");
const TutorialToken = artifacts.require("TutorialToken");
module.exports = function(deployer) {

  deployer.deploy(ComplianceServiceRegistry);
  deployer.deploy(ConfigurableComplianceService);
  deployer.deploy(ComplianceConfiguration);
  deployer.deploy(TutorialToken);
  //s1.setDefaultService(s2.address);
 

}
