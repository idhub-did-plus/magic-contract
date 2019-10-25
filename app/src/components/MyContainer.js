import MyComponent from "./MyComponent";
import {chooseMenu} from "../store/actions";
import PropTypes from 'prop-types'
import React from 'react'
import { connect } from 'react-redux'
import store from "../store/store"
function drizzleConnect(Component, ...args) {
  var ConnectedWrappedComponent = connect(...args)(Component)
  var s = store;
  const DrizzledComponent = (props, context) => {
    var pp = props;
    return (<ConnectedWrappedComponent {...props} store={s} />);
  }

  DrizzledComponent.contextTypes = {
    drizzleStore: PropTypes.object
  }

  return DrizzledComponent
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
const mapDispatchToProps = dispatch => {
  return {
   
    selectMenu: (index)=>dispatch(chooseMenu(index))
  };
};
const MyContainer = drizzleConnect(MyComponent, mapStateToProps, mapDispatchToProps);

export default MyContainer;
