import registry from "./contracts/ComplianceServiceRegistry.json";
import configurable from "./contracts/ConfigurableComplianceService.json";
import configuration from "./contracts/ComplianceConfiguration.json";
import TutorialToken from "./contracts/TutorialToken.json";

const options = {
  web3: {
    block: false,
    fallback: {
      type: "ws",
      url: "ws://127.0.0.1:8545",
    },
  },
  contracts: [registry, configurable, configuration],
  events: {
    SimpleStorage: ["StorageSet"],
  },
  polls: {
    accounts: 1500,
  },
};

export default options;
