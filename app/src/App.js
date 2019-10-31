import React, { Component } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";

import "./App.css";
import drizzle from "./store/MyDrizzleAndStore"
import ComponentContainer from "./components/ComponentContainer";
import LoginController from "./components/LoginController";

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
                <LoginController drizzle={drizzle}>
                  <ComponentContainer drizzle={drizzle} drizzleState={drizzleState} />
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
