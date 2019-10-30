import React, { Component } from "react";
import Erc1400Component from "./Erc1400Component";
import Erc20Component from "./Erc20Component";
import Erc777Component from "./Erc777Component";
import TokenStatisticsComponent from "./TokenStatisticsComponent";
import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

import { DrizzleContext } from "@drizzle/react-plugin";

export default function TokenComponent() {
  return <DrizzleContext.Consumer>
    {
      drizzleContext => {
        return <MyTokenComponent  {...drizzleContext} />
      }
    }
  </DrizzleContext.Consumer>
}
function MyTokenComponent(props) {

  return (
    <Router>
 <section id="wrap">
      <nav className="sidemenu">
        <ul >
          <li>
            <NavLink to="/erc20" activeClassName="active">Erc20 Token Deploy</NavLink>
          </li>
          <li>
            <NavLink to="/erc1400" activeClassName="active">Erc1400 Token Deploy</NavLink>
          </li>

          <li>
            <NavLink to="/erc770" activeClassName="active">Erc777 Token Deploy</NavLink>
          </li>
        </ul>
      </nav>
      <article className="wrapper">
        <Switch>
          <Route path="/erc20">
            <Erc20Component {...props} />
          </Route>
          <Route path="/erc1400">
            <Erc1400Component {...props} />
          </Route>

          <Route path="/erc777">
            <Erc777Component {...props} />
          </Route>
        </Switch>
      </article>
      </section>


    </Router>
  )

}
