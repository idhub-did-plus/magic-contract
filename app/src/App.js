import React, { Component } from "react";
import DrizzleProvider from "./MyDrizzleProvider";
import { LoadingContainer  } from "@drizzle/react-components";
import {Drizzle } from "drizzle";
import "./App.css";
import drizzle from "./MyDrizzle"
import drizzleOptions from "./store/drizzleOptions";
import store from "./store/store";
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
