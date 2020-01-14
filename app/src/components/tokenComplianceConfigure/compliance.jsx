import React,{Component} from "react"
import "./compliance.css"
import Swiper from "swiper"
import { DrizzleContext } from "@drizzle/react-plugin";
import ContractForm from "../contract/ContractForm"

class TokenComplianceConfigurationComponent extends Component{
    constructor(props){
        super(props)
        this.state = {
            display:false,
            option1:"residence",
            option2:"equal to",
            option3:"stCompliance-0.0.1-US",
            condition:[],
            swiper:null,
            end:"",
            tokenAddress:""
        }

        this.handleRegister = this.handleRegister.bind(this);
        this.handleSelect1 = this.handleSelect1.bind(this);
        this.handleSelect2 = this.handleSelect2.bind(this);
        this.handleSelect3 = this.handleSelect3.bind(this);
        this.handleAdd = this.handleAdd.bind(this);
        this.del = this.del.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.continue = this.continue.bind(this);
    }
    componentWillMount(){
        this.setState({
            tokenAddress:this.props.location.search.substring(9)
        })
    }
    componentDidMount(){
        //滑动滚轮实现表单翻页效果
        this.swiper = new Swiper(".swiper-container",{
            direction : 'vertical',
            mousewheelControl: true,
            pagination : '.swiper-pagination',
            paginationType : 'progress',
            slideToClickedSlide:true
        })
    }
    handleRegister(){
        this.swiper.slideTo(3, 1000, false);
        //调用合规服务注册合约
        this.contracts = this.props.drizzle.contracts;
        this.utils = this.props.drizzle.web3.utils;

        // Get the contract ABI and address
        const abi = this.contracts["ComplianceServiceRegistry"].abi;
        const address = this.contracts["ComplianceServiceRegistry"].address;
        var web3 = this.props.drizzle.web3;
        console.log(web3,this.contracts)
        var ComplianceServiceRegistry = new web3.eth.Contract(abi,address,{
            from: this.props.drizzleState.accounts[0]
        });
        
        var token = this.tokenAddr.value;
        var service = this.serviceAddr.value;
        
        if(!this.utils.isAddress(token)||!this.utils.isAddress(service)){
            alert("please input right address");
        }else{
            console.log(ComplianceServiceRegistry.methods)
            ComplianceServiceRegistry.methods.register(token,service).send({
                from:this.props.drizzleState.accounts[0],
                gas:30000
            });
        }
        
    }
    continue(){
        this.swiper.slideTo(7, 1000, false);
        var a = this.state.condition[0].replace(/equal to/g,"==");
        var b = a.replace(/not equal to/g,"!=")
        this.setState({
            end:b
        })
    }
    handleSubmit(){
        //调用合规配置合约
        this.contracts = this.props.drizzle.contracts;
        this.utils = this.props.drizzle.web3.utils;

        // Get the contract ABI and address
        const abi = this.contracts["ComplianceConfiguration"].abi;
        const address = this.contracts["ComplianceConfiguration"].address;
        var web3 = this.props.drizzle.web3;
        
        var ComplianceServiceRegistry = new web3.eth.Contract(abi,address);

        var token = this.tokenAddress.value;
        var configuration = this.str.innerText;
        
        if(!this.utils.isAddress(token)){
            alert("please input right address");
        }else{
            ComplianceServiceRegistry.methods.setConfiguration(token,configuration).send({
                from:this.props.drizzleState.accounts[0],
                gas:300000
            });
        }
    }
    //处理下拉框相关逻辑，实现合规条件拼接
    handleSelect1(){
        this.setState({
            display: !this.state.display
        })
        this.ul1.style.display = this.state.display ? "block":"none"
    }
    handleSelect2(){
        this.setState({
            display: !this.state.display
        })
        this.ul2.style.display = this.state.display ? "block":"none"
    }
    handleSelect3(){
        this.setState({
            display: !this.state.display
        })
        this.ul3.style.display = this.state.display ? "block":"none"
    }
    handleOption1(value){
        this.setState({
            option1: value
        })
        this.ul1.style.display = "none"
    }
    handleOption2(value){
        this.setState({
            option2: value
        })
        this.ul2.style.display = "none"
    }
    handleOption3(value){
        this.setState({
            option3: value
        })
        this.ul3.style.display = "none"
    }
    handleAdd(){
        this.setState({ 
            condition: [...this.state.condition,this.state.option1 + " " + this.state.option2 + " " + this.state.option3]
        })
    }
    handleAnd(value,e){
        var condition = this.state.condition;
        var newString = this.state.condition[value-1] + " && " + this.state.condition[value];
        condition[value-1] = newString;
        let n = this.state.condition.slice();
        n.splice(value,1)
        this.setState({
            condition:n
        })
    }
    handleOr(value,e){
        var condition = this.state.condition;
        var newString = this.state.condition[value-1] + " || " + this.state.condition[value];
        condition[value-1] = newString;
        let n = this.state.condition.slice();
        n.splice(value,1)
        this.setState({
            condition:n
        })
    }
    del(e){
        e.target.parentNode.childNodes[0].innerText = ""
    }
    render(){
        return (
            <div className="configure">
                <div className="swiper-container">
                    <div className="swiper-pagination"></div>
                    <div className="swiper-wrapper">
                        <div className="swiper-slide">
                            <div className='bg'></div>
                            <div className="questionBox">
                                <div className="question">
                                    <h2>
                                        <span>1</span>
                                        <span></span>
                                        Register
                                    </h2>
                                    <p className="detail">a. Please check your token address.</p>
                                    <input ref={el=>this.tokenAddr=el} type="text" className="input" defaultValue={this.state.tokenAddress} />
                                </div>
                            </div>
                        </div>
                        <div className="swiper-slide">
                            <div className='bg'></div>
                            <div className="questionBox">
                                <div className="question">
                                    <h2>
                                        <span>1</span>
                                        <span></span>
                                        Register
                                    </h2>
                                    <p className="detail">b. Please enter your compliance service address.</p>
                                    <input ref={el=>this.serviceAddr=el} type="text" className="input"/>
                                    <ContractForm contract="ComplianceServiceRegistry" method="register" labels={["token address", "compliance service address"]} />
                                </div>
                            </div>
                        </div> 
                        <div className="swiper-slide">
                            <div className='bg'></div>
                            <div className="questionBox">
                                <div className="question">
                                    <h2>
                                        <span>2</span>
                                        <span></span>
                                        Token Compliance
                                    </h2>
                                    <p className="detail">Please enter the compliance content to be configured.</p>
                                    <div className="next" onClick={this.handleRegister}>Continue</div>
                                </div>
                            </div>
                        </div>
                        <div className="swiper-slide" ref={el=>this.second = el}>
                            <div className='bg'></div>
                            <div className="questionBox">
                                <div className="question">
                                    <h2>
                                        <span>2</span>
                                        <span></span>
                                        Token Compliance
                                    </h2>
                                    <p className="detail">a. Please check your token address.</p>
                                    <input type="text" className="input" ref={el=>this.tokenAddress=el} defaultValue={this.state.tokenAddress} />
                                </div>
                            </div>
                        </div>
                        {/* <div className="swiper-slide">
                            <div className='bg'></div>
                            <div className="questionBox">
                                <div className="question">
                                    <h2>
                                        <span>2</span>
                                        <span></span>
                                        Token Compliance
                                    </h2>
                                    <p className="detail">b. Please enter your configuration. </p>
                                    <input type="text" className="input"/>
                                </div>
                            </div>
                        </div> */}
                        <div className="swiper-slide">
                            <div className='bg'></div>
                            <div className="questionBox">
                                <div className="question">
                                    <h2>
                                        <span>2</span>
                                        <span></span>
                                        Token Compliance
                                    </h2>
                                    <p className="detail">b. Please enter your component.  </p>
                                    <div className="select">
                                        <span className="text" ref={el=>this.option1=el}>{this.state.option1}</span>
                                        <span className="icon" onClick={this.handleSelect1}></span>
                                        <ul ref={el=>this.ul1=el} style={{display:"none"}}>
                                            <li onClick={this.handleOption1.bind(this,"residence")}>residence</li>
                                            <li onClick={this.handleOption1.bind(this,"nationality")}>nationality</li>
                                        </ul>
                                    </div>
                                    <div className="select">
                                        <span className="text" ref={el=>this.option2=el}>{this.state.option2}</span>
                                        <span className="icon" onClick={this.handleSelect2}></span>
                                        <ul ref={el=>this.ul2=el} style={{display:"none"}}>
                                            <li onClick={this.handleOption2.bind(this,"equal to")}>equal to</li>
                                            <li onClick={this.handleOption2.bind(this,"not equal to")}>not equal to</li>
                                        </ul>
                                    </div>
                                    <div className="select">
                                        <span className="text" ref={el=>this.option3=el}>{this.state.option3}</span>
                                        <span className="icon" onClick={this.handleSelect3}></span>
                                        <ul ref={el=>this.ul3=el} style={{display:"none"}}>
                                            <li onClick={this.handleOption3.bind(this,"stCompliance-0.0.1-US")}>stCompliance-0.0.1-US</li>
                                        </ul>
                                    </div>
                                    <div className="add" onClick={this.handleAdd}></div>
                                    {
                                        this.state.condition.map((e, index) => {
                                            let remove = () => {
                                                let n = this.state.condition.slice();
                                                n.splice(index, 1);
                                                this.setState(
                                                    {
                                                        condition: n
                                                    }
                                                )
                                            }
                                            return (
                                                <div key={index}>
                                                    <div className="condition">{e}{index}<span className="del" onClick={remove}></span></div>
                                                    <div ref={el=>this.andOrBox = el} className="andOrBox" style={{display:index==0 ? "none":"inline-block"}}>
                                                        <div className="and" onClick={this.handleAnd.bind(this,index)}></div>
                                                        <div className="or" onClick={this.handleOr.bind(this,index)}></div>
                                                    </div>
                                                </div>
                                            )
                                        })
                                    }
                                    <div className="next" onClick={this.continue}>Continue</div>
                                </div>
                            </div>
                        </div>
                        <div className="swiper-slide">
                            <div className='bg'></div>
                            <div className="questionBox">
                                <div className="question">
                                    <h2>
                                        <span>2</span>
                                        <span></span>
                                        Token Compliance
                                    </h2>
                                    <p className="detail">
                                        c. Please check that the information you filled in is correct？If the confirmation is correct, click the 
                                        submit button. 
                                    </p>
                                    <div className="show"><span ref={el=>this.str=el}>{this.state.end}</span><span className="del" onClick={this.del}></span></div>
                                    <div className="next" onClick={this.handleSubmit}>Submit</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        )
    }

}
// export default TokenComplianceConfigurationComponent;
export default (props) => {
    return (
      <DrizzleContext.Consumer>
        {drizzleContext => {
          return (
            <TokenComplianceConfigurationComponent {...drizzleContext} {...props} />
          );
        }}
      </DrizzleContext.Consumer>
  
    )
}