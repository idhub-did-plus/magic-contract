import React, { Component } from "react";
import DrizzleProvider from "./components/MyDrizzleProvider";
import { LoadingContainer  } from "@drizzle/react-components";
import "./App.css";
import drizzle from "./store/MyDrizzle"

import MyContainer from "./components/MyContainer";

//const drizzle = new Drizzle(drizzleOptions, store);
class App extends Component {
  render() {
     const old = 
     <DrizzleProvider  drizzle={drizzle}  >
         <LoadingContainer>
           <MyContainer />
         </LoadingContainer>
       </DrizzleProvider>;
    //  const newl = 
    //     <DrizzleContext.Provider drizzle={drizzle}>
    //          <LoadingContainer>
    //          <DrizzleContext.Consumer>
    //            <MyContainer />
    //            </DrizzleContext.Consumer>
    //          </LoadingContainer>
    //      </DrizzleContext.Provider>;
    return (
      old
      
    );
  }
}

export default App;
