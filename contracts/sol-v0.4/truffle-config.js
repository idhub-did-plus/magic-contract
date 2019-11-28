const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_directory: "./contracts/sol-v0.4",
  contracts_build_directory: path.join(__dirname, "app/src/contracts"),
  networks: {
    develop: {
      port: 7545
    }
  },
  compilers: {
    solc: {
      version: "^0.4.21"
    }
  }
};
