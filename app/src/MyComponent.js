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
      <h1>Drizzle Examples</h1>
      <p>Examples of how to get started with Drizzle in various situations.</p>
    </div>

    <div className="section">
      <h2>Active Account</h2>
      <AccountData accountIndex={0} units="ether" precision={3} />
    </div>

    <div className="section">
      <h2>ComplianceServiceRegistry</h2>
      <p>
        This shows a simple ContractData component with no arguments, along with
        a form to set its value.
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
        Here we have a form with custom, friendly labels. Also note the token
        symbol will not display a loading indicator. We've suppressed it with
        the <code>hideIndicator</code> prop because we know this variable is
        constant.
      </p>
      <p>
        <strong>getConfiguration: </strong>
        <ContractForm
          contract="ComplianceConfiguration"
          method="getConfiguration"
          labels={["token address"]}
        />{" "}
      
      </p>

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
        Finally this contract shows data types with additional considerations.
        Note in the code the strings below are converted from bytes to UTF-8
        strings and the device data struct is iterated as a list.
      </p>
     
    </div>
  </div>
);
