
import React from "react";
import { BrowserRouter as Router, Link, Route, Switch } from "react-router-dom";
import ComplianceComponent from "./compliance/ComplianceComponent";
import Topics from "./token/Topics";

export default function ComponentContainer() {
  return (
    <Router>
      <div>

        <ul className="topmenu">
          <li>
            <Link to="/compliance">Compliance</Link>
          </li>
          <li>
            <Link to="/about">About</Link>
          </li>
          <li>
            <Link to="/topics">Topics</Link>
          </li>
        </ul>

        <Switch>
          <Route path="/about">
            <About />
          </Route>
          <Route path="/topics">
            <Topics />
          </Route>
          <Route path="/compliance">
            <Compliance />
          </Route>
        </Switch>
      </div>
    </Router>
  );
}



function About() {
  return <h2>About</h2>;
}

function Compliance() {
  return <ComplianceComponent/>
}
