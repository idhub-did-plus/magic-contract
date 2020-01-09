
import "./login.css"
import React, { Component, Children } from "react";
import { DrizzleContext } from "@drizzle/react-plugin";
import { loginFinished } from "../../store/login/actions"
import { Dropdown, Button, Checkbox, Table, TableBody, TableCell, TableRow } from 'semantic-ui-react'



export default class LoginController extends Component {
  constructor(props, context) {
    super(props);
    this.state = {
      // checkFirst: true,
      // checkSecond :false,
      // spanDispaly: 'none',
      // checkDisplay: 'block',
      display: "block",
      claim:""
    };

    // this.handleClaimChange = this.handleClaimChange.bind(this);
    this.login = this.login.bind(this);
    this.handleCheck = this.handleCheck.bind(this);

  }
  async componentDidMount() {
    let json = await this.reentry();
    if(json != undefined &&json.success){
      this.props.drizzle.store.dispatch(loginFinished(json));
    }
    //this.props.drizzle.store.dispatch(login());

  }
  // handleClaimChange(key, text, value) {

  //   this.claim = text.value;

  // }
  handleCheck(){
    this.setState(prevState => ({
      checkFirst:!prevState.checkFirst,
      checkSecond:!prevState.checkSecond,
      spanDispaly: prevState.checkFirst ? "none":"block",
      checkDisplay: prevState.checkFirst ? "block":"none"
    }))
  }
  // handleCheck(){
  //   this.setState({
  //     checkFirst:!this.state.checkFirst,
  //     checkSecond:!this.state.checkSecond,
  //     spanDispaly: this.state.checkFirst ? "none":"block",
  //     checkDisplay: this.state.checkFirst ? "block":"none"
  //   })
  // }
  async login(event) {
    // if (this.claim == undefined) {
    //   alert("choose claim please!")
    //   return
    // }
    // if(this.state.checkFirst){
    //   this.claim = "tokenIssuer"
    // }
    // if(this.state.checkSecond){
    //   this.claim = "complianceManager"
    // }
    if(this.state.checkFirst){
      this.claim = "complianceManager"
    }
    if(this.state.checkSecond){
      this.claim = "tokenIssuer"
    }
    var myDate = new Date();
		var timestamp = myDate.getTime();
    let web3 = this.props.drizzle.web3;
    let identity =  this.props.drizzleState.accounts[0];
    var data = web3.utils.fromUtf8(identity + timestamp + this.claim)
    web3.eth.personal.sign(data, identity,async (error, signature)=>{
      
      let json = await this.request(identity, timestamp, this.claim, signature);
      if(json != undefined && json.success){
        this.props.drizzle.store.dispatch(loginFinished(json));
      }

      
    });

  }
  async request(identity, tp,claim, sig) {
    try {
      let response = await fetch('http://localhost:8080/login?identity='+identity+'&timestamp='+tp + '&claim=' + claim+ '&signature=' + sig, {
       
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
      return json;
    } catch (err) {
      alert(err);
    } finally {

    }
  }
  async reentry() {
    try {
      let response = await fetch('http://localhost:8080/login?action=reentry', {
       
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
      return json;
    } catch (err) {
      alert(err);
    } finally {

    }
  }
  render() {
    let login = this.props.drizzle.store.getState().login;
    if (login.success === true) {
      // Load the dapp.
      return Children.only(this.props.children)
    }

    return (
      // Display a loading indicator.
      
      // <main className="login">
      //   <h1>⚙️</h1>
      //   <p>Login dapp...</p>
      //   <Dropdown
      //     placeholder='Select Country'

      //     search
      //     selection
      //     options={countryOptions}
      //     onChange={this.handleClaimChange}
      //   />
      //    <button class="ui primary button"  onClick={this.login}>Login</button>

      // </main>
      <div className="loginController">
                <div className="container">
                    <p>Please select your indetity to log in</p>
                    <div className="login">
                        <div className="select" onClick={this.handleCheck}>
                            compliance Manager
                            <span style={{display: this.state.spanDispaly}}></span>
                            <span className="icon" style={{display: this.state.checkDisplay}}></span>
                        </div>
                        <div className="select" onClick={this.handleCheck}>
                            token Issuer
                            <span style={{display: this.state.checkDisplay}}></span>
                            <span className="icon" style={{display: this.state.spanDispaly}}></span>
                        </div>
                        <div className="logBtn" onClick={this.login}>Login</div>
                    </div>
                </div>
                <div className="bg"></div>
            </div>
    )
  }
}

// const countryOptions = [
//   { key: 'complianceManager', value: 'complianceManager', text: 'complianceManager' },
//   { key: 'tokenIssuer', value: 'tokenIssuer', text: 'tokenIssuer' },

// ]

