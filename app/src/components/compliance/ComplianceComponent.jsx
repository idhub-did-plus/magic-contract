import React, { Component } from "react";
import { chooseMenu } from "../../store/actions"
import SideMenu from "../common/SideMenu"
import ContractData from "../contract/ContractData";
import ContractForm from "../contract/ContractForm";
import { BrowserRouter as Router, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

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
                  <Link to="/registry">Compliance Service Registry</Link>
                </li>
                <li>
                  <Link to="/configuration">Compliance Configuration</Link>
                </li>
                <li>
                  <Link to="/configurable">Configurable Compliance Service</Link>
                </li>
                <li>
                  <Link to="/">Claim Registry</Link>
                </li>
                <li>
                  <Link to="/">Distributed Identity</Link>
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

      <strong>getConfiguration: </strong>
      <ContractForm  {...props}
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

      </p>
      <p>
        This contract is the current default service of the compliance service registry.
      </p>
    </div>
  )
}