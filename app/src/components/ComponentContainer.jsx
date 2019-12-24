
import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import ComplianceComponent from "./compliance/ComplianceComponent";
import TokenComponent from "./token/TokenComponent";
import TokenStatisticsComponent from "./token/TokenStatisticsComponent";
import {Button } from 'semantic-ui-react'

export default function ComponentContainer(props) {
  let claim = props.drizzleState.login.claim;
  async function logout() {
     
    try {
      let response = await fetch('http://localhost:8080/logout', {
       
        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
        credentials: 'include', // include, same-origin, *omit
        headers: {
          'user-agent': 'Mozilla/4.0 MDN Example',
          'content-type': 'application/json'
        },
        method: 'GET', // *GET, POST, PUT, DELETE, etc.
        mode: 'cors', // no-cors, cors, *same-origin
        redirect: 'follow', // manual, *follow, error
        referrer: 'no-referrer', // *client, no-referrer
      })
      let json = response.json() // parses response to JSON
      alert(json)
      window.location.reload(true);
      
    } catch (err) {
      alert(err);
    } finally {

    }
  
  }
  return (
    <Router >


          <ul className="topmenu">
            <li>
              <div className="logo">
              </div>
              <p className="logoText">MagicCircle</p>
            </li>
            <li hidden={claim !=="complianceManager"} style={{ marginLeft: '110px' }}>
              <NavLink to="/compliance">Compliance</NavLink>
            </li>

            <li hidden={claim !=="tokenIssuer"} >
              <NavLink to="/token">TokenComponent</NavLink>
            </li>

            <li>
              <NavLink to="/statistics">TokenStatisticsComponent</NavLink>
            </li>
            <li>
            <NavLink to=""  onClick={logout}>logout</NavLink>
            
            </li>
          </ul>

          <Switch>
            <Route path="/token">
              <TokenComponent />
            </Route>
            <Route path="/statistics">
              <TokenStatisticsComponent />
            </Route>
            <Route path="/compliance">
              <Compliance />
            </Route>
          </Switch>
          <div className="status"></div>



    </Router>
  );
}




function Compliance() {
  return <ComplianceComponent />
}
