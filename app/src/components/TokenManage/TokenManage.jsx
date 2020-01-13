import React from "react";
import { BrowserRouter as Router, NavLink } from "react-router-dom";
import "./TokenManage.css"
import Header from "../common/Header"
import { Component } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";

class TokenManage extends Component {
  constructor(){
    super()
    
    this.state = {
      shadowDisplay:"none",
      detailDisplay:"none",
      detailContent: null
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
                <h1><span className="icon"></span>Manage your security tokens</h1>
                <div className="manageBox">
                    <div>
                      <p>Create New Security Token</p>
                      <NavLink to="deploy"><button>GET START</button></NavLink>
                    </div>
                        {
                          this.props.drizzleState.deployedTokens.map((el,index) =>{
                            return(
                              <div key={index}>
                                <section className="open" onClick={this.showDetail.bind(this,el)}></section>
                                <p>
                                  {el.symbol}
                                  <br/>
                                  <span>{el.contractAddress}</span>  
                                </p>
                                <section className="btnBox">
                                  <NavLink to={`compliance?address=${el.contractAddress}`}><button className="configure">Configure</button></NavLink>
                                  <NavLink to={`issue?address=${el.contractAddress}`}><button className="issue">Issue</button></NavLink>
                                </section>
                              </div>
                            ) 
                          })
                        }
                </div>
            </div>
            {/* 遮罩层 */}
            <div className="shadow" style={{display:this.state.shadowDisplay}} onClick={this.closeShadow.bind(this)}></div>
            {/* 详细信息 */}
            <div className="showDetail" style={{display:this.state.detailDisplay}}>
              {
                this.state.detailContent?(
                  <ul>
                      <li>
                        <span>Name</span>
                        <p>{this.state.detailContent.name}</p>
                      </li>
                      <li>
                        <span>Symbol</span>
                        <p>{this.state.detailContent.symbol}</p>
                      </li>
                      <li>
                        <span>TokenAddress</span>
                        <p>{this.state.detailContent.contractAddress}</p>
                      </li>
                      <li>
                        <span>Decimals</span>
                        <p>{this.state.detailContent.decimals.words[0]}</p>
                      </li>
                      <li>
                        <span>Controllers</span>
                        <div>
                            {
                              this.state.detailContent.controllers.map((item,index)=>{
                                return (
                                    <p key={index}>{item}<br/></p>
                                )
                              })
                            }
                        </div>
                      </li>
                      <li>
                        <span>RegistryAddress</span>
                        <p>{this.state.detailContent.registryAddress}</p>
                      </li>
                      <li>
                        <span>DeployAccount</span>
                        <p>{this.state.detailContent.deployAccount}</p>
                      </li>
                      <li>
                        <span>Congifuration</span>
                        <p>111</p>
                      </li>
                  </ul>
                ):(null)
              }
                
            </div>
        </div>
    );
  }
  showDetail(content){
    this.setState({
      shadowDisplay:"block",
      detailDisplay:"block",
      detailContent: content
    })
  }
  closeShadow(){
    this.setState({
      shadowDisplay:"none",
      detailDisplay:"none"
    })
  }
  
}

export default (props) => {
  return (
    <DrizzleContext.Consumer>
      {drizzleContext => {
        return (
          <TokenManage {...drizzleContext} {...props} />
        );
      }}
    </DrizzleContext.Consumer>

  )
}




