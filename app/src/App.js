import React, { Component } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";

import "./App.css";
import drizzle from "./store/MyDrizzleAndStore"
import MyComponent from "./components/MyComponent";

//const drizzle = new Drizzle(drizzleOptions, store);
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
              <MyComponent drizzle={drizzle} drizzleState={drizzleState} />
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
