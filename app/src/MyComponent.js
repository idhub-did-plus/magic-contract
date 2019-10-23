import React from "react";
import {
  AccountData,
  ContractData,
  ContractForm,
} from "@drizzle/react-components";

import logo from "./logo.png";

export default ({ accounts,currentMenu }) => (
  <div className="App">
    <ul class="topmenu">
      <li><a href="#home" class="active">主页</a></li>
      <li><a href="#news">新闻</a></li>
      <li><a href="#contact">联系我们</a></li>
      <li><a href="#about">关于我们</a></li>
    </ul>
    <div class="column sidemenu">
        <ul>
         
          <li><a href="#flight">The Flight</a></li>
          <li><a href="#city" class="active">The City</a></li>
          <li><a href="#island">The Island</a></li>
          <li><a href="#food">The Food</a></li>
          <li><a href="#people">The People</a></li>
          <li><a href="#history">The History</a></li>
          <li><a href="#oceans">The Oceans</a></li>
        </ul>
    </div>
    <div>
    <div>
      
      <h1>Magic Circle Compliace System</h1>
      <p>A console for management of compliance system</p>
    </div>

    <div className="section">
      <h2>Active Account</h2>
      <AccountData accountIndex={0} units="ether" precision={3} />
    </div>
    <h2>dd{currentMenu}</h2>
    <div className="section" hidden = {currentMenu != 0}>
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

    <div className="section" hidden = {currentMenu != 1}>
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
    <div className="section" hidden = {currentMenu != 2}>
      <h2>ConfigurableComplianceService</h2>
      <p>
      
      </p>
      <p>
        This contract is the current default service of the compliance service registry. 
      </p>
      </div>
    </div>
  </div>
);
