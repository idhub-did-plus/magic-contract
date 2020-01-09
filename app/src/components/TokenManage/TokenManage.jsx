import React from "react";
import { BrowserRouter as Router, NavLink, Route, Switch } from "react-router-dom";
import "./TokenManage.css"
import Header from "../common/Header"
import { Component, Children } from "react";

export default class TokenManage extends Component {
  constructor(){
    super()
    
    this.state = {
      shadowDisplay:"none",
      detailDisplay:"none"
    }

  }
  render(){
    return (
        <div className="all">
            {/* header */}
            <div className="first">
              <Header />
            </div>
            
            {/* content */}
            <div className="bottom">
                <h1><a href=""></a>Manage your security tokens</h1>
                <div className="manageBox">
                  <div>
                    <p>Create New Security Token</p>
                    <button>GET START</button>
                  </div>
                  <div>
                    <section className="open" onClick={this.showDetail.bind(this,"aaa")}></section>
                    <p>
                      Symbol
                      <br/>
                      <span>0x21B761B8db1e5279E367d78b488bAA2c0ff4111A</span>  
                    </p>
                    <section className="btnBox">
                      <NavLink to="compliance"><button class="configure">Configure</button></NavLink>
                      <button class="issue">Issue</button>
                    </section>
                  </div>
                  <div>
                    <section className="open" onClick={this.showDetail.bind(this,"bbb")}></section>
                    <p>
                      Symbol
                      <br/>
                      <span>0x87CCC36B36398330c17f0450C2C779A2f18Ab461</span>  
                    </p>
                    <section className="btnBox">
                      <NavLink to="compliance"><button class="configure">Configure</button></NavLink>
                      <button class="issue">Issue</button>
                    </section>
                  </div>
                </div>
            </div>
            {/* 遮罩层 */}
            <div className="shadow" style={{display:this.state.shadowDisplay}} onClick={this.closeShadow.bind(this)}></div>
            {/* 详细信息 */}
            <div className="showDetail" style={{display:this.state.detailDisplay}}>
                <ul>
                  <li>
                    <span>Name</span>
                    <p>1</p>
                  </li>
                  <li>
                    <span>Symbol</span>
                    <p>1</p>
                  </li>
                  <li>
                    <span>TokenAddress</span>
                    <p>1</p>
                  </li>
                  <li>
                    <span>Decimals</span>
                    <p>1</p>
                  </li>
                  <li>
                    <span>Controllers</span>
                    <p>
                        <section>1</section>
                        <section>2</section>
                        <section>3</section>
                    </p>
                  </li>
                  <li>
                    <span>DeployAccount</span>
                    <p>1</p>
                  </li>
                  <li>
                    <span>Congifuration</span>
                    <p>111</p>
                  </li>
                </ul>
            </div>
        </div>
    );
  }
  showDetail(){
    this.setState({
      shadowDisplay:"block",
      detailDisplay:"block"
    })
  }
  closeShadow(){
    this.setState({
      shadowDisplay:"none",
      detailDisplay:"none"
    })
  }
  
}




