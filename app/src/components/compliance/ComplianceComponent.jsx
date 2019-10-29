import React, { Component } from "react";
import {chooseMenu} from "../../store/actions"
import SideMenu from "../common/SideMenu"
import ContractData from "../contract/ContractData";
import ContractForm from "../contract/ContractForm";

import { DrizzleContext } from "@drizzle/react-plugin";
class MyComponentInternal extends Component {
    constructor() {
      super();
  
    }
  
  
    render() {
      return (
        <div>
          <section>
  
  
            <SideMenu dd={this.context} currentMenu={this.props.currentMenu} selectMenu={this.props.selectMenu} />
            <article className="wrapper">
              <div className="section" hidden={this.props.currentMenu !== 0}>
  
                <p className="desc"><b>   Compliance Service Registry: {this.props.ComplianceServiceRegistry.address}</b>
                  A  central place for tokens to  appoint their special compliance check logic and if not,  use a default one.
              </p>
                <p>
                  <strong>DefaultService: </strong>
                  <ContractData contract="ComplianceServiceRegistry" method="getDefaultService" {...this.props}/>
                </p>
  
                <h2>setDefaultService</h2>
                <ContractForm  {...this.props} contract="ComplianceServiceRegistry" method="setDefaultService" labels={["service address"]} />
                <h2>register</h2>
                <ContractForm  {...this.props} contract="ComplianceServiceRegistry" method="register" labels={["token address", "compliance service address"]} />
              </div>
  
              <div className="section" hidden={this.props.currentMenu !== 1}>
                <h2>ComplianceConfiguration: </h2>
                <p>
                  A place to configure the claim logic for token which use ConfigurableComplianceService
              </p>
  
                <strong>getConfiguration: </strong>
                <ContractForm  {...this.props}
                  contract="ComplianceConfiguration"
                  method="getConfiguration"
                  labels={["token address"]}
                />
  
  
                <h3>Send Tokens</h3>
                <ContractForm  {...this.props}
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
            </article>
          </section>
          <footer>mmmm</footer>
        </div>
      )
    }
  }
  const mapStateToProps = state => {
    return {
      accounts: state.accounts,
      ComplianceServiceRegistry: state.contracts.ComplianceServiceRegistry,
      ConfigurableComplianceService: state.contracts.ConfigurableComplianceService,
      ComplianceConfiguration: state.contracts.ComplianceConfiguration,
      TutorialToken: state.contracts.TutorialToken,
      drizzleStatus: state.drizzleStatus,
      currentMenu: state.currentMenu,
     
    };
  };
  
  export default function ComplianceComponent() {
    return <DrizzleContext.Consumer>
      {drizzleContext => {
        const { drizzle, drizzleState, initialized } = drizzleContext;
  
        return <MyComponentInternal  selectMenu={(index)=>drizzle.store.dispatch(chooseMenu(index))} {...mapStateToProps(drizzleState)} drizzle={drizzle} drizzleState={ drizzleState }/>
      }
      }
    </DrizzleContext.Consumer>
  }