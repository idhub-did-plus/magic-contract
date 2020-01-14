import React, { Component } from "react";

// import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";
import {  Form, Checkbox } from 'semantic-ui-react'
import { deployFinished1400 } from "../../store/token/actions";
import { DrizzleContext } from "@drizzle/react-plugin";
import TokenListComponent from "./TokenListComponent"

import ERC1400 from "../../contracts/ERC1400.json";
var contract = require("@truffle/contract");


class Erc1400DeployComponent extends Component {
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
    if (this.formData.name == undefined || this.formData.symbol == undefined || this.formData.decimals == undefined) {
      alert("select token please!")
      return
    }
    if (this.formData.name.length == 0 || this.formData.symbol.length == 0 || this.formData.decimals.length == 0) {
      alert("select token please!")
      return
    }
    // if(!this.utils.isBN( this.formData.decimals)){
    //   alert("select decimals!")
    //   return
    // }


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
          deployAccount: this.props.drizzleState.accounts[0],
          tokenType: "erc1400"
        };
        this.props.drizzle.store.dispatch(deployFinished1400(payload))
        this.save(payload)
      }).then(
        //部署成功后跳转至配置与发行入口
          setTimeout(()=>{
            this.props.history.push({
              pathname:"/manage"
            })
          },3000)
      )
    
    return;
  }
 async save(token) {
    try {
      let response = await fetch("http://localhost:8080/saveDeployedToken", {
        body: JSON.stringify(token), // must match 'Content-Type' header
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'same-origin', // include, same-origin, *omit
        headers: {
          'user-agent': 'Mozilla/4.0 MDN Example',
          'content-type': 'application/json'
        },
        method: 'POST', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, cors, *same-origin
        redirect: 'follow', // manual, *follow, error
        referrer: 'no-referrer', // *client, no-referrer
      })
      let json = response.json() // parses response to JSON
    } catch (err) {
      alert(err);
    } finally {

    }
  }

  handleInputChange(event) {

    const value =
      event.target.type === "checkbox"
        ? event.target.checked
        : event.target.value;
    this.formData[event.target.name] = value;

  }
  handleAddController(event) {
    if (!this.utils.isAddress(this.formData.controller)) {
      alert("input address!")
      return
    }
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


          <div role="list" className="ui list">
            {this.formData.controllers.map((el,index) => <div role="listitem" className="item" key={index}>{el}</div>)}

          </div>
          <Form.Field>
            <label>controller</label>
            <input placeholder='controller' name="controller" />
          </Form.Field>
          <button onClick={this.handleAddController}>add controller</button>
          {/* <Button onClick={this.handleAddController}>add controller</Button> */}
          <Form.Field>
            <Checkbox label='I agree to the Terms and Conditions' />
          </Form.Field>
          <button onClick={this.handleSubmit}>Submit</button>
          {/* <Button onClick={this.handleSubmit}>Submit</Button> */}
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
          <Erc1400DeployComponent {...drizzleContext} {...props} />
        );
      }}
    </DrizzleContext.Consumer>

  )
}