const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const TutorialToken = artifacts.require("TutorialToken");
const ConfigurableComplianceService = artifacts.require("ConfigurableComplianceService");

module.exports = async function(deployer) {

  deployer.deploy(ComplianceServiceRegistry),
  deployer.deploy(ConfigurableComplianceService),
  deployer.deploy(TutorialToken);
  //s1.setDefaultService(s2.address);
 

}
