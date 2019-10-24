import MyComponent from "./MyComponent";
import { drizzleConnect } from "@drizzle/react-plugin";
import {chooseMenu} from "./actions";
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
function mapDispatchToProps(dispatch) {
  return {
    selectMenu: index => dispatch(chooseMenu(index))
  };
}
const MyContainer = drizzleConnect(MyComponent, mapStateToProps, mapDispatchToProps);

export default MyContainer;
