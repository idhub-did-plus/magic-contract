

import React, { Component, Children } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";
import {login} from "../store/login/actions"

 export default class LoginController extends Component {
    constructor(props, context) {
      super(props)
    }
    componentDidMount(){
      this.props.drizzle.store.dispatch(login());

    }
    render() {
    let login = this.props.drizzle.store.getState().login;
      if (login === true)
      {
        // Load the dapp.
        return Children.only(this.props.children)
      }
  
      return(
        // Display a loading indicator.
        <main>
          <h1>⚙️</h1>
          <p>Login dapp...</p>
        </main>
      )
    }
  }
 