const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const ConfigurableComplianceService = artifacts.require("ConfigurableComplianceService");
const ComplianceConfiguration = artifacts.require("ComplianceConfiguration");
const TutorialToken = artifacts.require("TutorialToken");
module.exports = function(deployer) {
  let addr0 = "0x0000000000000000000000000000000000000000"
  deployer.deploy(ComplianceServiceRegistry);
  deployer.deploy(ConfigurableComplianceService, addr0,addr0,addr0,addr0);
  deployer.deploy(ComplianceConfiguration);
  deployer.deploy(TutorialToken);
  //s1.setDefaultService(s2.address);
 

}
