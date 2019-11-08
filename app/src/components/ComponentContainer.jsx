
import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import ComplianceComponent from "./compliance/ComplianceComponent";
import TokenComponent from "./token/TokenComponent";
import TokenStatisticsComponent from "./token/TokenStatisticsComponent";


export default function ComponentContainer() {
  return (
    <Router>
      <div className="all">
        <div className="first">

          <ul className="topmenu">
            <li>
              <div className="logo">
              </div>
              <p className="logoText">MagicCircle</p>
            </li>
            <li style={{marginLeft:'110px'}}>
              <NavLink to="/compliance">Compliance</NavLink>
            </li>
            <li>
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
        </div>
       
      </div>
    </Router>
  );
}




function Compliance() {
  return <ComplianceComponent />
}
