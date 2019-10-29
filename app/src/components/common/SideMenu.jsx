import React,{Component} from "react"

export default class SideMenu extends Component {
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
        <nav className="sidemenu">
          <ul>
  
            <li ><p id="0" onClick={this.handleChoose} className={this.props.currentMenu === 0 ? "active" : ""}>Compliance Service Registry</p></li>
            <li ><p id="1" onClick={this.handleChoose} className={this.props.currentMenu === 1 ? "active" : ""}>Compliance Configuration</p></li>
            <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 2 ? "active" : ""}>Configurable Compliance Service</p></li>
            <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 3 ? "active" : ""}>Claim Registry</p></li>
            <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 4 ? "active" : ""}>Distributed Identity</p></li>
            <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 5 ? "active" : ""}>0x management</p></li>
            <li ><p id="2" onClick={this.handleChoose} className={this.props.currentMenu === 6 ? "active" : ""}>Token Mint</p></li>
  
          </ul>
        </nav>
      )
    }
  }