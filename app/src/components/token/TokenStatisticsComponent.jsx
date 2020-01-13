import React from "react";
// import ContractData from "../contract/ContractData";
// import ContractForm from "../contract/ContractForm";
// import ContractDataForm from "../contract/ContractDataForm";
import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

// import { DrizzleContext } from "@drizzle/react-plugin";

export default function TokenStatisticsComponent(props) {

    return (
        <Router>
     <section className="SideContainer">
          <nav className="sidemenu">
            <ul >
              <li>
                <NavLink to="/erc20stat" activeClassName="active">Erc20 Token Statistics</NavLink>
              </li>
              <li>
                <NavLink to="/erc1400stat" activeClassName="active">Erc1400 Token Statistics</NavLink>
              </li>
    
              <li>
                <NavLink to="/erc777stat" activeClassName="active">Erc777 Token Statistics</NavLink>
              </li>
            </ul>
          </nav>
          <article className="wrapper">
            <Switch>
              <Route path="/erc20stat">
                <Erc20StatComponent {...props} />
              </Route>
              <Route path="/erc1400stat">
                <Erc1400StatComponent {...props} />
              </Route>
    
              <Route path="/erc777stat">
                <Erc777StatComponent {...props} />
              </Route>
            </Switch>
          </article>
          </section>
    
    
        </Router>
      )
    function Erc20StatComponent(){
        return (
            <div className="mysection">
              <h2>Erc20: </h2>
              <p>
                A place to statstics erc1400 security token
              </p>
            </div>
          )
    }
    function Erc777StatComponent(){
        return (
            <div className="mysection">
              <h2>Erc777: </h2>
              <p>
                A place to statstics erc777 security token
              </p>
            </div>
          )
    }
    function Erc1400StatComponent(){
        return (
            <div className="mysection">
              <h2>Erc1400: </h2>
              <p>
                A place to statstics erc1400 security token
              </p>
            </div>
          )
    }
}
