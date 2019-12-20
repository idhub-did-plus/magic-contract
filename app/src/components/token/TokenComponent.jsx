import { DrizzleContext } from "@drizzle/react-plugin";
import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import TokenDeployComponent from "./TokenDeployComponent";
import TokenIssueComponent from "./TokenIssueComponent";
import TokenComplianceConfigurationComponent from "./TokenComplianceConfigurationComponent";

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
 <section className="SideContainer">
      <nav className="sidemenu">
        <ul >
          <li>
            <NavLink to="/deploy" activeClassName="active"> Token Deploy</NavLink>
          </li>
          <li>
            <NavLink to="/issue" activeClassName="active"> Token Issue</NavLink>
          </li>
          <li>
            <NavLink to="/compliance" activeClassName="active"> Token Compliance</NavLink>
          </li>

        </ul>
      </nav>
      <article className="wrapper">
        <Switch>
          <Route path="/deploy">
            <TokenDeployComponent  />
          </Route>
          <Route path="/issue">
            <TokenIssueComponent {...props} />
          </Route>
          <Route path="/compliance">
            <TokenComplianceConfigurationComponent {...props} />
          </Route>

        </Switch>
      </article>
      </section>


    </Router>
  )

}
