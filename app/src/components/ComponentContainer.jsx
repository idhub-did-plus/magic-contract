
import PropTypes from 'prop-types';
import React, { Component } from "react";
import { BrowserRouter as Router, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

import {chooseMenu} from "../store/actions"
import SideMenu from "./common/SideMenu"
import Topics from "./token/Topics"
import ComplianceComponent from "./compliance/ComplianceComponent"
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
