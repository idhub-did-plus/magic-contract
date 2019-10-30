import React, { Component } from "react";
import ContractData from "../contract/ContractData";
import ContractForm from "../contract/ContractForm";
import ContractDataForm from "../contract/ContractDataForm";
import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

import { DrizzleContext } from "@drizzle/react-plugin";
class MyTokenComponent extends Component {
  constructor() {
    super();

  }

  render() {

    return (
      <Router>
      
        <div id="wrap">
            <nav className="sidemenu">
              <ul>
                <li>
                  <NavLink to="/token_creation" activeClassName="active">Token Creation</NavLink>
                </li>
                <li>
                  <NavLink to="/token_statistics"  activeClassName="active">Token Statistics</NavLink>
                </li>
               
              </ul>
            </nav>
            <article className="wrapper">
              <Switch>
                <Route path="/token_creation">
                  <TokenCreation {...this.props} />
                </Route>
                <Route path="/token_statistics">
                  <TokenStatistics {...this.props} />
                </Route>
                
              </Switch>
            </article>
          </div>

       
      </Router>
    )
  }
}

export default function TokenComponent() {
  return <DrizzleContext.Consumer>
    {
      drizzleContext => {
      return <MyTokenComponent  {...drizzleContext} />
      }
    }
  </DrizzleContext.Consumer>
}
function TokenCreation(props) {

  return (
    <div className="mysection">

      <p className="desc"><b>   Compliance Service Registry: {props.drizzle.contracts.ComplianceServiceRegistry.address}</b>
        A  central place for tokens to  appoint their special compliance check logic and if not,  use a default one.
  </p>
      </div>
  )

}
function TokenStatistics(props) {

  return (
    <div className="mysection">
      <h2>ComplianceConfiguration: </h2>
      <p>
        A place to configure the claim logic for token which use ConfigurableComplianceService
</p>

    </div>
  )
}
