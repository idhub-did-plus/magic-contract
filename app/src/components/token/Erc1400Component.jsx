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
    this.utils = props.drizzle.web3.utils;
    this.MyContract = MyContract;
    this.formData = { controllers: [] };


    this.handleInputChange = this.handleInputChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleAddController = this.handleAddController.bind(this);
  }
  //https://github.com/trufflesuite/truffle/tree/master/packages/contract
  handleSubmit(event) {
    event.preventDefault();
    let web3 = this.props.drizzle.web3;
    this.MyContract.setProvider(web3.currentProvider);
    
 
    this.MyContract.new( 
      this.formData.name,
      this.formData.symbol,
      this.utils.toBN(this.formData.decimals),
      this.formData.controllers,
      this.props.drizzle.contracts.ComplianceServiceRegistry.address, {from:  this.props.drizzleState.accounts[0]}).then(inst=>{
        window.alert(inst.address)
      })
    return;
  }

  handleInputChange(event) {

    const value =
      event.target.type === "checkbox"
        ? event.target.checked
        : event.target.value;
    this.formData[event.target.name] = value;

  }
  handleAddController(event) {
    const value = this.formData.controllers.push(this.formData.controller)
  }
  // string memory name,
  // string memory symbol,
  // uint256 decimals,
  // address[] memory controllers,
  // address  ConfigurableComplianceServiceaddr
  render() {

    return (
      <div className="mysection">
        <h2>Erc1400: </h2>
        <p>A place to deploy erc1400 security token</p>
        <div
          onSubmit={this.handleSubmit} onChange={this.handleInputChange}
        >
          <Form.Field>
            <label>Token Name</label>
            <input placeholder='name' name="name" />
          </Form.Field>
          <Form.Field>
            <label>Tonen Symbol</label>
            <input placeholder='symbol' name="symbol" />
          </Form.Field>
          <Form.Field>
            <label>decimals</label>
            <input placeholder='decimals' type="" name="decimals" />
          </Form.Field>
          <Form.Field>
            <label>Address of Compliance Service Registry</label>
            <input type="address" placeholder='CompolianceServiceRegistry' name="registryAddress" disabled value={this.props.drizzle.contracts.ComplianceServiceRegistry.address} ></input>
          </Form.Field>


          <div role="list" class="ui list">
            {this.formData.controllers.map(el => <div role="listitem" class="item">{el}</div>)}

          </div>
          <Form.Field>
            <label>controller</label>
            <input placeholder='controller' name="controller" />
          </Form.Field>
          <Button onClick={this.handleAddController}>add controller</Button>
          <Form.Field>
            <Checkbox label='I agree to the Terms and Conditions' />
          </Form.Field>

          <Button onClick={this.handleSubmit}>Submit</Button>
        </div>
      </div>
    )
  }
}