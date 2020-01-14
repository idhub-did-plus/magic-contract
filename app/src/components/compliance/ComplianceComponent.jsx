import React, { Component } from "react";

import ContractData from "../contract/ContractData";
import ContractForm from "../contract/ContractForm";
import ContractDataForm from "../contract/ContractDataForm";
import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

import { DrizzleContext } from "@drizzle/react-plugin";
class MyComponentInternal extends Component {
  constructor() {
    super();

  }

  render() {

    return (
      <Router>

        <section className="SideContainer">
          <nav className="sidemenu">
            <ul >
              <li>
                <NavLink to="/registry" activeClassName="active">Compliance Service Registry</NavLink>
              </li>
              <li>
                <NavLink to="/configuration" activeClassName="active">Compliance Configuration</NavLink>
              </li>
              <li>
                <NavLink to="/configurable" activeClassName="active">Configurable Compliance Service</NavLink>
              </li>
              <li>
                <NavLink to="/claimRegistry"  >Claim Registry</NavLink>
              </li>
              <li>
                <NavLink to="/distributedIdentity"  >Distributed Identity</NavLink>
              </li>
            </ul>
          </nav>
          <article className="wrapper">
            <Switch>
              <Route path="/registry">
                <Registry />
              </Route>
              <Route path="/configuration">
                <Configuration />
              </Route>
              <Route path="/configurable">
                <Configurable />
              </Route>
              <Route path="/claimRegistry">
                <ClaimRegistry />
              </Route>
              <Route path="/distributedIdentity">
                <DistributedIdentity />
              </Route>
            </Switch>
          </article>
        </section>

      </Router>
    )
  }
}


export default function ComplianceComponent() {
  

      return <MyComponentInternal />
 
}
function Registry(props) {

  return (
    <div className="mysection">

      <p className="desc"><b>   Compliance Service Registry</b>
        A  central place for tokens to  appoint their special compliance check logic and if not,  use a default one.
  </p>
      <p>

      </p>
      <p>
        <p>Default Service: </p>
        <ContractData contract="ComplianceServiceRegistry" method="getDefaultService" />
      </p>

      <p>set default service</p>
      <ContractForm contract="ComplianceServiceRegistry" method="setDefaultService" labels={["service address"]} />
      <p>register</p>
      <ContractForm contract="ComplianceServiceRegistry" method="register" labels={["token address", "compliance service address"]} />
    </div>
  )
}
function Configuration(props) {

  return (
    <div className="mysection">
      <h2>ComplianceConfiguration: </h2>
      <p>
        A place to configure the claim logic for token which use ConfigurableComplianceService
      </p>

      <p>getConfiguration: </p>
      <ContractDataForm
        contract="ComplianceConfiguration"
        method="getConfiguration"
        labels={["token address"]}
      />


      <p>set token compliace configuation</p>
      <ContractForm
        contract="ComplianceConfiguration"
        method="setConfiguration"
        labels={["token address", "configuarion"]}
      />
    </div>
  )
}
function Configurable(props) {

  return (
    <div className="mysection" >
      <h2>Configurable Compliance Service</h2>

      <p>
        This contract is the current default service of the compliance service registry.
      </p>
    </div>
  )
}

function ClaimRegistry(props) {

  return (
    <div className="mysection" >
      <h2>ClaimRegistry</h2>

      <p>
        ClaimRegistry
      </p>
    </div>
  )
}


function DistributedIdentity(props) {

  return (
    <div className="mysection" >
      <h2>DistributedIdentity</h2>

      <p>
        DistributedIdentity
      </p>
    </div>
  )
}