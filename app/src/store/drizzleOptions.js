import ComplianceServiceRegistry from "../contracts/ComplianceServiceRegistry.json";
import ConfigurableComplianceService from "../contracts/ConfigurableComplianceService.json";
import ComplianceConfiguration from "../contracts/ComplianceConfiguration.json";
import TutorialToken from "../contracts/TutorialToken.json";
const options = {
  web3: {
    block: false,
    fallback: {
      type: "ws",
      url: "ws://127.0.0.1:8545",
    },
  },
  contracts: [ComplianceServiceRegistry, ConfigurableComplianceService, ComplianceConfiguration, TutorialToken],
  events: {
   
  },
  polls: {
    accounts: 1500,
  }
};

export default options;
