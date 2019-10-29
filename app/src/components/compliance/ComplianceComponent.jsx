import React, { Component } from "react";
import { chooseMenu } from "../../store/actions"
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
        <div>
          <section>
            <nav className="sidemenu">
              <ul>
                <li>
                  <NavLink to="/registry" activeClassName="active">Compliance Service Registry</NavLink>
                </li>
                <li>
                  <NavLink to="/configuration"  activeClassName="active">Compliance Configuration</NavLink>
                </li>
                <li>
                  <NavLink to="/configurable"  activeClassName="active">Configurable Compliance Service</NavLink>
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
                  <Registry {...this.props} />
                </Route>
                <Route path="/configuration">
                  <Configuration {...this.props} />
                </Route>
                <Route path="/configurable">
                  <Configurable {...this.props} />
                </Route>
                <Route path="/claimRegistry">
                  <ClaimRegistry {...this.props} />
                </Route>
                <Route path="/distributedIdentity">
                  <DistributedIdentity {...this.props} />
                </Route>
              </Switch>
            </article>
          </section>
          <footer>mmmm</footer>
        </div>
      </Router>
    )
  }
}
const mapStateToProps = state => {
  return {

    currentMenu: state.currentMenu,

  };
};

export default function ComplianceComponent() {
  return <DrizzleContext.Consumer>
    {drizzleContext => {
      const { drizzle, drizzleState, initialized } = drizzleContext;

      return <MyComponentInternal selectMenu={(index) => drizzle.store.dispatch(chooseMenu(index))} {...mapStateToProps(drizzleState)} drizzle={drizzle} drizzleState={drizzleState} />
    }
    }
  </DrizzleContext.Consumer>
}
function Registry(props) {

  return (
    <div className="section">

      <p className="desc"><b>   Compliance Service Registry: {props.drizzle.contracts.ComplianceServiceRegistry.address}</b>
        A  central place for tokens to  appoint their special compliance check logic and if not,  use a default one.
  </p>
  <p>
          {props.drizzle.contracts.ComplianceServiceRegistry.address}
      </p>
      <p>
        <strong>DefaultService: </strong>
        <ContractData contract="ComplianceServiceRegistry" method="getDefaultService" {...props} />
      </p>

      <h2>setDefaultService</h2>
      <ContractForm  {...props} contract="ComplianceServiceRegistry" method="setDefaultService" labels={["service address"]} />
      <h2>register</h2>
      <ContractForm  {...props} contract="ComplianceServiceRegistry" method="register" labels={["token address", "compliance service address"]} />
    </div>
  )

}
function Configuration(props) {

  return (
    <div className="section">
      <h2>ComplianceConfiguration: </h2>
      <p>
        A place to configure the claim logic for token which use ConfigurableComplianceService
</p>
<p>
          {props.drizzle.contracts.ComplianceConfiguration.address}
      </p>
      <strong>getConfiguration: </strong>
      <ContractDataForm  {...props}
        contract="ComplianceConfiguration"
        method="getConfiguration"
        labels={["token address"]}
      />


      <h3>Send Tokens</h3>
      <ContractForm  {...props}
        contract="ComplianceConfiguration"
        method="setConfiguration"
        labels={["token address", "configuarion"]}
      />
    </div>
  )
}
function Configurable(props) {

  return (
    <div className="section" >
      <h2>Configurable Compliance Service</h2>
      <p>
          {props.drizzle.contracts.ConfigurableComplianceService.address}
      </p>
      <p>
        This contract is the current default service of the compliance service registry.
      </p>
    </div>
  )
}

function ClaimRegistry(props) {

  return (
    <div className="section" >
      <h2>ClaimRegistry</h2>

      <p>
      ClaimRegistry
      </p>
    </div>
  )
}


function DistributedIdentity(props) {

  return (
    <div className="section" >
      <h2>DistributedIdentity</h2>

      <p>
      DistributedIdentity
      </p>
    </div>
  )
}