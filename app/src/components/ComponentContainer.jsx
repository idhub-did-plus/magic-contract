
import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import ComplianceComponent from "./compliance/ComplianceComponent";
import TokenComponent from "./token/TokenComponent";
import TokenStatisticsComponent from "./token/TokenStatisticsComponent";


export default function ComponentContainer(props) {
  let claim = props.drizzleState.login.claim;
  return (
    <Router >


          <ul className="topmenu">
            <li>
              <div className="logo">
              </div>
              <p className="logoText">MagicCircle</p>
            </li>
            <li hidden={claim !=="complianceManager"} style={{ marginLeft: '110px' }}>
              <NavLink to="/compliance">Compliance</NavLink>
            </li>

            <li hidden={claim !=="tokenIssuer"} >
              <NavLink to="/token">TokenComponent</NavLink>
            </li>

            <li>
              <NavLink to="/statistics">TokenStatisticsComponent</NavLink>
            </li>
          </ul>

          <Switch>
            <Route path="/token">
              <TokenComponent />
            </Route>
            <Route path="/statistics">
              <TokenStatisticsComponent />
            </Route>
            <Route path="/compliance">
              <Compliance />
            </Route>
          </Switch>
          <div className="status"></div>



    </Router>
  );
}




function Compliance() {
  return <ComplianceComponent />
}
