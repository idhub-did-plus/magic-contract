import { DrizzleContext } from "@drizzle/react-plugin";
import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import TokenDeployComponent from "./TokenDeployComponent";
import TokenIssueComponent from "./TokenIssueComponent";


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
            <NavLink to="/deploy" activeClassName="active"> Token Deploy</NavLink>
          </li>
          <li>
            <NavLink to="/issue" activeClassName="active"> Token Issue</NavLink>
          </li>

        </ul>
      </nav>
      <article className="wrapper">
        <Switch>
          <Route path="/deploy">
            <TokenDeployComponent {...props} />
          </Route>
          <Route path="/issue">
            <TokenIssueComponent {...props} />
          </Route>

        </Switch>
      </article>
      </section>


    </Router>
  )

}
