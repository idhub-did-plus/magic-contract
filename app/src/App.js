import React, { Component } from "react";
import { DrizzleProvider } from "@drizzle/react-plugin";
import { LoadingContainer } from "@drizzle/react-components";

import "./App.css";

import drizzleOptions from "./store/drizzleOptions";
import store from "./store/store";
import MyContainer from "./components/MyContainer";

class App extends Component {
  render() {
    return (
      <DrizzleProvider options={drizzleOptions}  store={store}>
        <LoadingContainer>
          <MyContainer />
        </LoadingContainer>
      </DrizzleProvider>
    );
  }
}

export default App;
