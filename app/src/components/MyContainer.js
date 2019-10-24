import MyComponent from "./MyComponent";
import {chooseMenu} from "../store/actions";
import { drizzleConnect } from "@drizzle/react-plugin";

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
const MyContainer = drizzleConnect(MyComponent, mapStateToProps,mapDispatchToProps);

export default MyContainer;
