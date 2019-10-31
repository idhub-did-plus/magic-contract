import React, { Component } from "react";

import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";
import { Button, Form, Checkbox } from 'semantic-ui-react'
import { DrizzleContext } from "@drizzle/react-plugin";

import ERC1400 from "../../contracts/ERC1400.json";
var contract = require("@truffle/contract");

export default class Erc1400Component extends Component {
  constructor(props) {
    super(props);
    
    var MyContract = contract(ERC1400)
   
    this.MyContract = MyContract;
    this.formData = {};

    this.handleInputChange = this.handleInputChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);

  }
//https://github.com/trufflesuite/truffle/tree/master/packages/contract
  handleSubmit(event) {
    event.preventDefault();
    let web3 = this.props.drizzle.web3;
    this.MyContract.setProvider(web3.currentProvider);
    
    this.MyContract.new();
    return ;
  }

  handleInputChange(event) {
    const value =
      event.target.type === "checkbox"
        ? event.target.checked
        : event.target.value;
      
      this.formData[event.target] = value;
   
  }

  render() {
   
    return (
      <div className="mysection">
        <h2>Erc1400: </h2>
        <p>A place to deploy erc1400 security token</p>
        <Form
         onSubmit={this.handleSubmit}   onChange={this.handleInputChange}
        >
          <Form.Field>
            <label>First Name</label>
            <input placeholder='First Name' />
          </Form.Field>
          <Form.Field>
            <label>Last Name</label>
            <input placeholder='Last Name' />
          </Form.Field>
          <Form.Field>
            <Checkbox label='I agree to the Terms and Conditions' />
          </Form.Field>
          <Button type='submit'>Submit</Button>
        </Form>
      </div>
    )
  }
}