import React, { Component } from "react";
import { BrowserRouter as Router, NavLink } from "react-router-dom";
import Header from "../../components/common/Header"
import imgUrl from "../../assets/arrow@2x.png"
import "./home.css"

export default class Home extends Component {
  
  render(){
      return (
        <div className="all">
          <div className="first">
            <Header />
          </div>
        <div className="second">
          <div className="textBox">
            <div>MagicCircle</div>
            <div>Programmable independent value management model for global digital 
                securities issuance platforms Through the tokenization, compliance issuance 
                and trading of various types of assets, the free flow and value realization
                of assets around the world are realized.</div>
            <div><NavLink to="manage">MANAGE YOUR SECURITY TOKEN <span><img src={imgUrl} alt="出错了"/></span></NavLink></div>
          </div>
        </div>
        </div>
    );
  }
  
}
