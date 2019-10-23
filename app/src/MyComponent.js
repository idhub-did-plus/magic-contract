import React from "react";
import {
  AccountData,
  ContractData,
  ContractForm,
} from "@drizzle/react-components";

import logo from "./logo.png";

export default ({ accounts }) => (
  <div className="App">
    <div>
      <img src={logo} alt="drizzle-logo" />
      <h1>Magic Circle Compliace System</h1>
      <p>A console for management of compliance system</p>
    </div>

    <div className="section">
      <h2>Active Account</h2>
      <AccountData accountIndex={0} units="ether" precision={3} />
    </div>

    <div className="section">
      <h2>Compliance Service Registry</h2>
      <p>
        A  central place for tokens to  appoint their special compliance check logic and if not,  use a default one.
      </p>
      <p>
        <strong>DefaultService: </strong>
        <ContractData contract="ComplianceServiceRegistry" method="getDefaultService"  />
      </p>
      <h2>setDefaultService</h2>
      <ContractForm contract="ComplianceServiceRegistry" method="setDefaultService" labels={["service address"]}  />
      <h2>register</h2>
      <ContractForm contract="ComplianceServiceRegistry" method="register" labels={["token address", "compliance service address"]}  />
    </div>

    <div className="section">
      <h2>ComplianceConfiguration</h2>
      <p>
        A place to configure the claim logic for token which use ConfigurableComplianceService
      </p>

        <strong>getConfiguration: </strong>
        <ContractForm
          contract="ComplianceConfiguration"
          method="getConfiguration"
          labels={["token address"]}
        />
    

      <h3>Send Tokens</h3>
      <ContractForm
        contract="ComplianceConfiguration"
        method="setConfiguration"
        labels={["token address", "configuarion"]}
      />
    </div>
    <div className="section">
      <h2>ConfigurableComplianceService</h2>
      <p>
        This contract is the current default service of the compliance service registry. 
      </p>
     
    </div>
  </div>
);
