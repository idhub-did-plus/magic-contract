import React, { Component } from "react";
import {
  AccountData,
  ContractData,
  ContractForm,
} from "@drizzle/react-components";
import PropTypes from 'prop-types'

class SideMenu extends Component {
  constructor() {
    super();
    this.handleChoose = this.handleChoose.bind(this);
  }
  handleChoose(event) {
    event.preventDefault();
    let index = parseInt(event.target.id);
    this.props.selectMenu(index);

  }
  render() {
    return (
      <div className="column sidemenu">
      <ul>

        <li ><p id="0" onClick={this.handleChoose} className={this.props.currentMenu === 0?"active":""}>Compliance Service Registry</p></li>
        <li ><p id="1" onClick={this.handleChoose} className={this.props.currentMenu === 1?"active":""}>Compliance Configuration</p></li>
        <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 2?"active":""}>Configurable Compliance Service</p></li>
        <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 3?"active":""}>Claim Registry</p></li>
        <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 4?"active":""}>Distributed Identity</p></li>
        <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 5?"active":""}>0x management</p></li>
        <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 6?"active":""}>Token Mint</p></li>

      </ul>
    </div>
    )
  }
}
export default class MyComponent extends Component {
  constructor() {
    super();
    
  }
 
  
  render() {
    return (
      <div className="App">

        <div >
          <ul className="topmenu">
            <li><a href="#home" className="active">主页</a></li>
            <li><a href="#news">新闻</a></li>
            <li><a href="#contact">联系我们</a></li>
            <li><a href="#about">关于我们</a></li>
            <p>Magic Circle Compliace System</p>

          </ul>
        </div>
        <SideMenu dd={this.context} currentMenu={this.props.currentMenu} selectMenu= {this.props.selectMenu}/>
        <div className="wrapper">
          <div className="section" hidden={this.props.currentMenu !== 0}>

            <p className="desc"><b>   Compliance Service Registry: {this.props.ComplianceServiceRegistry.address}</b>
              A  central place for tokens to  appoint their special compliance check logic and if not,  use a default one.
            </p>
            <p>
              <strong>DefaultService: </strong>
              <ContractData contract="ComplianceServiceRegistry" method="getDefaultService" />
            </p>
           
            <h2>setDefaultService</h2>
            <ContractForm contract="ComplianceServiceRegistry" method="setDefaultService" labels={["service address"]} />
            <h2>register</h2>
            <ContractForm contract="ComplianceServiceRegistry" method="register" labels={["token address", "compliance service address"]} />
          </div>

          <div className="section" hidden={this.props.currentMenu !== 1}>
            <h2>ComplianceConfiguration: </h2>
            <p>
              A place to configure the claim logic for token which use ConfigurableComplianceService
            </p>

            <strong>getConfiguration: </strong>
            <ContractForm
              contract="ComplianceConfiguration"
              method="getConfiguration"
              labels={["token address"]}
            />


            <h3>Send Tokens</h3>
            <ContractForm
              contract="ComplianceConfiguration"
              method="setConfiguration"
              labels={["token address", "configuarion"]}
            />
          </div>
          <div className="section" hidden={this.props.currentMenu !== 2}>
            <h2>Configurable Compliance Service</h2>
            <p>

            </p>
            <p>
              This contract is the current default service of the compliance service registry.
            </p>
          </div>
        </div>
      </div>
    )
  }
}
MyComponent.contextTypes = {
  drizzleStore: PropTypes.object
};