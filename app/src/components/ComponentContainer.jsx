
import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import ComplianceComponent from "./compliance/ComplianceComponent";
import TokenComponent from "./token/TokenComponent";
import Topics from "./token/Topics";

export default function ComponentContainer() {
  return (
    <Router>
      <div className="all">
        <div className="first">

          <ul className="topmenu">
            <li>
              <NavLink to="/compliance">Compliance</NavLink>
            </li>
            <li>
              <NavLink to="/token">TokenComponent</NavLink>
            </li>
            <li>
              <NavLink to="/topics">Topics</NavLink>
            </li>
          </ul>
        
          <Switch>
            <Route path="/token">
              <TokenComponent />
            </Route>
            <Route path="/topics">
              <Topics />
            </Route>
            <Route path="/compliance">
              <Compliance />
            </Route>
          </Switch>
        </div>
        <div className="second">99999</div>
      </div>
    </Router>
  );
}



function About() {
  return <h2>About</h2>;
}

function Compliance() {
  return <ComplianceComponent />
}
