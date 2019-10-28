import React, { Component } from "react";
import {
  AccountData,
  ContractData,
  ContractForm,
} from "@drizzle/react-components";
import PropTypes from 'prop-types'
import { drizzleConnect } from "@drizzle/react-plugin";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useRouteMatch,
  useParams
} from "react-router-dom";
import {chooseMenu} from "../store/actions";
export default function MyComponent() {
  return (
    <Router>
      <div>
        <ul  className="topmenu">
          <li>
            <Link to="/">Home</Link>
          </li>
          <li>
            <Link to="/about">About</Link>
          </li>
          <li>
            <Link to="/topics">Topics</Link>
          </li>
        </ul>

        <Switch>
          <Route path="/about">
            <About />
          </Route>
          <Route path="/topics">
            <Topics />
          </Route>
          <Route path="/">
            <Home />
          </Route>
        </Switch>
      </div>
    </Router>
  );
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

function About() {
  return <h2>About</h2>;
}

function Topics() {
  let match = useRouteMatch();

  return (
    <div>
      <h2>Topics</h2>

      <ul>
        <li>
          <Link to={`${match.url}/components`}>Components</Link>
        </li>
        <li>
          <Link to={`${match.url}/props-v-state`}>
            Props v. State
          </Link>
        </li>
      </ul>

      {/* The Topics page has its own <Switch> with more routes
          that build on the /topics URL path. You can think of the
          2nd <Route> here as an "index" page for all topics, or
          the page that is shown when no topic is selected */}
      <Switch>
        <Route path={`${match.path}/:topicId`}>
          <Topic />
        </Route>
        <Route path={match.path}>
          <h3>Please select a topic.</h3>
        </Route>
      </Switch>
    </div>
  );
}

function Topic() {
  let { topicId } = useParams();
  return <h3>Requested topic ID: {topicId}</h3>;
}

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
  class MyComponentInternal extends Component {
  constructor() {
    super();
    
  }
 
  
  render() {
    return (
      <div className="App">

        <div >
          <ul className="topmenu">

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
const DoIt = drizzleConnect(MyComponentInternal, mapStateToProps, mapDispatchToProps);
function Home() {
  return <DoIt />
}