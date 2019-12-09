

import React, { Component, Children } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";
import { login } from "../store/login/actions"
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
  login(event){

  }
  render() {
    let login = this.props.drizzle.store.getState().login;
    if (login === true) {
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
  { key: 'af', value: 'af', text: 'Afghanistan' },
  { key: 'ax', value: 'ax', text: 'Aland Islands' },
  { key: 'al', value: 'al', text: 'Albania' },
]

