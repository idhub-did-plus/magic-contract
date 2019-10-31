
import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import ComplianceComponent from "./compliance/ComplianceComponent";
import TokenComponent from "./token/TokenComponent";
import TokenStatisticsComponent from "./token/TokenStatisticsComponent";
import Topics from "./token/Topics";

export default class LoginController extends Component {
    constructor(props, context) {
      super(props)
    }
  
    render() {
      if (this.props.web3.status === 'failed')
      {
        return(
          // Display a web3 warning.
          <main>
            <h1>⚠️</h1>
            <p>This browser has no connection to the Ethereum network. Please use the Chrome/FireFox extension MetaMask, or dedicated Ethereum browsers Mist or Parity.</p>
          </main>
        )
      }
  
      if (this.props.drizzleStatus.initialized)
      {
        // Load the dapp.
        return Children.only(this.props.children)
      }
  
      return(
        // Display a loading indicator.
        <main>
          <h1>⚙️</h1>
          <p>Loading dapp...</p>
        </main>
      )
    }
  }
