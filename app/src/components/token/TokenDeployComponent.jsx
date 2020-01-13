import React from "react";
import Erc1400DeployComponent from "./Erc1400DeployComponent";
import Erc20DeployComponent from "./Erc20DeployComponent";
import Erc777DeployComponent from "./Erc777DeployComponent";
import TokenListComponent from "./TokenListComponent";
// import TokenStatisticsComponent from "./TokenStatisticsComponent";
import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

import { DrizzleContext } from "@drizzle/react-plugin";

export default function TokenComponent() {
    return <DrizzleContext.Consumer>
        {
            drizzleContext => {
                return <MyTokenComponent  {...drizzleContext} />
            }
        }
    </DrizzleContext.Consumer>
}
function MyTokenComponent(props) {

    return (


        <div >

            <Router>

                <ul className="topmenu">
                    <li>
                        <NavLink to="/erc20" activeClassName="active">Erc20</NavLink>
                    </li>
                    <li>
                        <NavLink to="/erc1400" activeClassName="active">Erc1400</NavLink>
                    </li>

                    <li>
                        <NavLink to="/erc770" activeClassName="active">Erc777</NavLink>
                    </li>
                </ul>
                <TokenListComponent {...props} />
                <Switch>
                    <Route path="/erc20">
                        <Erc20DeployComponent {...props} />
                    </Route>
                    <Route path="/erc1400">
                        <Erc1400DeployComponent {...props} />
                    </Route>

                    <Route path="/erc777">
                        <Erc777DeployComponent {...props} />
                    </Route>
                </Switch>
            </Router>
            
        </div>
    )
}
