import React, { Component } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";

import "./App.css";
import drizzle from "./store/MyDrizzleAndStore"
import ComponentContainer from "./components/ComponentContainer";

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
              <ComponentContainer drizzle={drizzle} drizzleState={drizzleState} />
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
