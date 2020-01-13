import React, { Component } from "react";

import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";
import { Button, Form, Checkbox, Table, TableBody, TableCell, TableRow } from 'semantic-ui-react'
import { deployFinished1400 } from "../../store/token/actions";
import { DrizzleContext } from "@drizzle/react-plugin";

import ERC1400 from "../../contracts/ERC1400.json";
var contract = require("@truffle/contract");
import TokenListComponent from "./TokenListComponent"

class Erc1400IssueComponent extends Component {
  constructor(props) {
    super(props);

    var MyContract = contract(ERC1400)
    this.utils = props.drizzle.web3.utils;
    this.MyContract = MyContract;
    this.formData = { controllers: [] };
    this.deployedTokens = [];


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
      this.props.drizzle.contracts.ComplianceServiceRegistry.address, { from: this.props.drizzleState.accounts[0] }).then(inst => {
      let payload = {
          name: this.formData.name,
          symbol: this.formData.symbol,
          decimals: this.utils.toBN(this.formData.decimals),
          controllers: this.formData.controllers.slice(0),
          registryAddress: this.props.drizzle.contracts.ComplianceServiceRegistry.address,
          contractAddress: inst.address,
          deployAccount: this.props.drizzleState.accounts[0]
        };
        this.props.drizzle.store.dispatch(deployFinished1400(payload))
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
        <TokenListComponent />
        <div
          onChange={this.handleInputChange}
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

export default (props) => {
  return (
    <DrizzleContext.Consumer>
      {drizzleContext => {
        return (
          <Erc1400IssueComponent {...drizzleContext} {...props} />
        );
      }}
    </DrizzleContext.Consumer>

  )
}