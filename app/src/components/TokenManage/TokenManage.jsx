import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import "./TokenManage.css"
import Header from "../common/Header"

export default function TokenManage() {
  return (
      <div className="all">
        <div className="first">

          <Header />
        </div>
        <div className="bottom">
            <h1><a href=""></a>Manage your security tokens</h1>
            <div className="manageBox">
              <div>
                <p>Configure New Security Token</p>
                <NavLink to="compliance"><button>GET START</button></NavLink>
              </div>
              <div>
                <p>
                  TokenName
                  <br/>
                  <span>tokensymbol</span>  
                </p>
                <button>OPEN</button>
              </div>
              <div>
              <p>
                  TokenName
                  <br/>
                  <span>tokensymbol</span>  
                </p>
                <button>OPEN</button>
              </div>
            </div>
        </div>
      </div>
  );
}




