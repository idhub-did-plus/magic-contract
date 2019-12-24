import { DrizzleContext } from "@drizzle/react-plugin";
import React, { Component } from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import TokenDeployComponent from "./TokenDeployComponent";
import TokenIssueComponent from "./TokenIssueComponent";
import TokenComplianceConfigurationComponent from "./TokenComplianceConfigurationComponent";
import mytokens from "../../service/TokenService"
import { tokenLoaded } from "../../store/token/actions";
export default function TokenComponent() {
  return <DrizzleContext.Consumer>
    {
      drizzleContext => {
        return <MyTokenComponent  {...drizzleContext} />
      }
    }
  </DrizzleContext.Consumer>
}
class MyTokenComponent extends Component {
  constructor(props) {
    super(props);
    let identity = this.props.drizzleState.accounts[0];
    mytokens(identity).then((tokens)=>{
      this.props.drizzle.store.dispatch(tokenLoaded(tokens))
    });
   
  }
  render() {
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
                <TokenDeployComponent />
              </Route>
              <Route path="/issue">
                <TokenIssueComponent {...this.props} />
              </Route>
              <Route path="/compliance">
                <TokenComplianceConfigurationComponent {...this.props} />
              </Route>

            </Switch>
          </article>
        </section>


      </Router>
    )
  }
}
