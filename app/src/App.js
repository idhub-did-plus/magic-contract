import React, { Component } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";

// import "./App.css";
import drizzle from "./store/MyDrizzleAndStore"
import ComponentContainer from "./components/ComponentContainer";
import LoginController from "./components/LoginController/LoginController";
import Home from "./components/home/Home"
import TokenManage from "./components/TokenManage/TokenManage"
import Compliance from "./components/tokenComplianceConfigure/compliance"
import ERC1400Deploy from "./components/token/Erc1400DeployComponent"
import ERC1400Issue from "./components/token/TokenIssueComponent"
import Configure from "./components/compliance/ComplianceComponent"

class App extends Component {
  render() {

    const newl =
      <DrizzleContext.Provider drizzle={drizzle}>
      
          <DrizzleContext.Consumer>
            {drizzleContext => {
              const { drizzle, drizzleState, initialized } = drizzleContext;

              if (!initialized) {
                return "Loading...";
              }
              return (
                <LoginController drizzle={drizzle} drizzleState={drizzleState}>
                  {/* <ComponentContainer drizzle={drizzle} drizzleState={drizzleState} /> */}
                  <Router>
                      <Route path="/" component={Home} exact/>
                      <Route path="/manage" component={TokenManage} exact/>
                      <Route path="/compliance" component={Compliance} exact/>
                      <Route path="/deploy" component={ERC1400Deploy} exact/>
                      <Route path="/issue" component={ERC1400Issue} exact/>
                  </Router>
                </LoginController>
              );
            }}
          </DrizzleContext.Consumer>
      
      </DrizzleContext.Provider>;
    return (
      newl

    );
  }
}

export default App;
