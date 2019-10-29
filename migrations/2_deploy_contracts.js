const ComplianceServiceRegistry = artifacts.require("ComplianceServiceRegistry");
const ConfigurableComplianceService = artifacts.require("ConfigurableComplianceService");
const ComplianceConfiguration = artifacts.require("ComplianceConfiguration");
const TutorialToken = artifacts.require("TutorialToken");
module.exports = function (deployer) {
  var addr0 = '0x0000000000000000000000000000000000000000';
  deployer.deploy(ComplianceServiceRegistry).then(function () {
    return deployer.deploy(ConfigurableComplianceService, addr0, addr0, addr0, addr0);
  }).then(function () {
    deployer.deploy(ComplianceConfiguration);
  }

  )




}
