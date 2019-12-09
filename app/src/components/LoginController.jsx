

import React, { Component, Children } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";
import { loginFinished } from "../store/login/actions"
import { Dropdown, Button, Checkbox, Table, TableBody, TableCell, TableRow } from 'semantic-ui-react'



export default class LoginController extends Component {
  constructor(props, context) {
    super(props)

    this.handleClaimChange = this.handleClaimChange.bind(this);
    this.login = this.login.bind(this);

  }
  componentDidMount() {

    //this.props.drizzle.store.dispatch(login());

  }
  handleClaimChange(key, text, value) {

    this.claim = text.value;

  }
  async login(event) {
    if (this.claim == undefined) {
      alert("choose claim please!")
      return
    }
    var myDate = new Date();
		var timestamp = myDate.getTime();
    let web3 = this.props.drizzle.web3;
    let identity =  this.props.drizzleState.accounts[0];
    var data = web3.utils.fromUtf8(identity + timestamp + this.claim)
    web3.eth.personal.sign(data, identity,async (error, signature)=>{
      
      let json = await this.request(identity, timestamp, this.claim, signature);
      if(json.success){
        this.props.drizzle.store.dispatch(loginFinished(json));
      }

      
    });

  }
  async request(identity, tp,claim, sig) {
    try {
      let response = await fetch('http://localhost:8080/login?identity='+identity+'&timestamp='+tp + '&claim=' + claim+ '&signature=' + sig, {
       
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, same-origin, *omit
        headers: {
          'user-agent': 'Mozilla/4.0 MDN Example',
          'content-type': 'application/json'
        },
        method: 'GET', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, cors, *same-origin
        redirect: 'follow', // manual, *follow, error
        referrer: 'no-referrer', // *client, no-referrer
      })
      let json = response.json() // parses response to JSON
      return json;
    } catch (err) {
      alert(err);
    } finally {

    }
  }

  render() {
    let login = this.props.drizzle.store.getState().login;
    if (login.success === true) {
      // Load the dapp.
      return Children.only(this.props.children)
    }

    return (
      // Display a loading indicator.
      <main>
        <h1>⚙️</h1>
        <p>Login dapp...</p>
        <Dropdown
          placeholder='Select Country'

          search
          selection
          options={countryOptions}
          onChange={this.handleClaimChange}
        />
        <Button
          onClick={this.login}
        />
      </main>
    )
  }
}

const countryOptions = [
  { key: 'complianceManager', value: 'complianceManager', text: 'complianceManager' },
  { key: 'tokenIssuer', value: 'tokenIssuer', text: 'tokenIssuer' },

]

