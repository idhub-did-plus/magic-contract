import React, { Component } from "react";

import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";
import { Dropdown, DropdownItem, Form, Button, Table, TableBody, TableCell, TableRow } from 'semantic-ui-react'
import { deployFinished1400 } from "../../store/token/actions";

import ERC1400 from "../../contracts/ERC1400.json";
import TokenListComponent from "./TokenListComponent";
var contract = require("@truffle/contract");

export default class TokenComplianceConfigurationComponent extends Component {
    constructor(props) {
        super(props);
        this.state = {
       
            attribute: "",
            logic: "",
            value: "",
            and: [],
            or: [],
            attribute: "empty"
        }


        this.handleAttributeChange = this.handleAttributeChange.bind(this);
        this.handleLogicChange = this.handleLogicChange.bind(this);
        this.handleValueChange = this.handleValueChange.bind(this);
        this.handleAddAnd = this.handleAddAnd.bind(this);
        this.handleAddOr = this.handleAddOr.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }
    async handleAddAnd(event) {
        if (this.state.attribute.length == 0 || this.state.logic.length == 0 || this.state.value.length == 0) {
            alert("invalid data!")
            return
        }
        this.setState({ and: [...this.state.and, this.state.attribute + this.state.logic + this.state.value] })
    }
    async handleAddOr(event) {

        let and = this.state.and;
        let rst = "";
        for (let i = 0; i < and.length; i++) {
            if (i == 0)
                rst = and[i];
            else
                rst += ("&&" + and[i]);
        }
        this.setState({ or: [...this.state.or, rst] })
    }
    async handleSubmit(event) {
        event.preventDefault();
        if (this.tokenAddress == undefined) {
            alert("choose token")
            return
        }
        if (this.state.or.length == 0) {
            alert("make rule")
            return
        }

        let or = this.state.or;
        let rst = "";
        for (let i = 0; i < or.length; i++) {
            if (i == 0)
                rst = or[i];
            else
                rst += ("||" + or[i]);
        }
        const config = this.props.drizzle.contracts["ComplianceConfiguration"];
        let method = config.methods["setConfiguration"];
        let dataKey = method.cacheSend(this.tokenAddress, rst);

        this.setState({ ...this.state, dataKey: dataKey });
        return dataKey;

    }

    handleAttributeChange(key, text, value) {

        this.setState(
            { attribute: text.value });

    }
    handleLogicChange(key, text, value) {

        this.setState(
            { logic: text.value });

    }
    handleValueChange(key, text, value) {

        this.setState(
            { value: text.value });

    }
    handleAddController(event) {
        const value = this.formData.controllers.push(this.formData.controller)
    }
    select = (addr) => {
        this.tokenAddress = addr;
        const config = this.props.drizzle.contracts["ComplianceConfiguration"];
        let method = config.methods["getConfiguration"];
        this.dataKey = method.cacheCall(addr);
        
    }
    currentConfig = ()=>{
        if(this.dataKey == undefined)
        return "emply";
        const config = this.props.drizzleState.contracts["ComplianceConfiguration"];
        if(!config.synced)
            return " 🔄";

        let displayData = config["getConfiguration"][this.dataKey];
        if(displayData == undefined)
            return "empty"
        displayData = displayData.value;
        if(displayData == undefined)
            return "emply";
        return displayData;

    }
    render() {
        const vs = attribute_values[this.state.attribute];
        return (
            <div className="box">

                <TokenListComponent {...this.props} select={this.select}></TokenListComponent>

                <div
                    onChange={this.handleInputChange}
                >
                    <Form.Field>
                        <label>token address</label>
                        <input placeholder='tokenAddress' name="tokenAddress" value={this.tokenAddress} />
                    </Form.Field>
                    <Form.Field>
                        <label>configuration</label>
                        <input placeholder='configuration' name="configuration" value={this.currentConfig()} />
                    </Form.Field>

                </div>

                <Table >
                    <Table.Body>
                        <Table.Row>
                            <Table.Cell className="cell"> <Dropdown
                                placeholder='Select Attribute'
                                fluid
                                selection
                                options={attribute_options}
                                onChange={this.handleAttributeChange}
                            /></Table.Cell>
                            <Table.Cell className="cell"> <Dropdown
                                placeholder='Select Logic'
                                fluid
                                selection
                                onChange={this.handleLogicChange}
                                options={logic_options}
                            /></Table.Cell>
                            <Table.Cell className="cell"><Dropdown
                                placeholder='Select value'
                                fluid
                                selection
                                onChange={this.handleValueChange}
                                options={vs}
                            /></Table.Cell>

                        </Table.Row>

                    </Table.Body>
                </Table>

                <button onClick={this.handleAddAnd}>Add And Component</button>
                <Table collapsing>


                    <Table.Body>
                        {
                            this.state.and.map((e, index) => {
                                let remove = () => {
                                    let n = this.state.and.slice();
                                    n.splice(index, 1);

                                    this.setState(
                                        {

                                            and: n
                                        }
                                    )
                                }
                                return (
                                    <Table.Row >

                                        <Table.Cell>{e}</Table.Cell>
                                        <Table.Cell><Button className="btn" value="remove" onClick={remove} >remove</Button></Table.Cell>

                                    </Table.Row>
                                )
                            })}
                    </Table.Body>
                </Table>


                <button onClick={this.handleAddOr}>Add Or Component</button>

                <Table collapsing>


                    <Table.Body>
                        {
                            this.state.or.map((e, index) => {
                                let remove = () => {
                                    let n = this.state.or.slice();
                                    n.splice(index, 1);

                                    this.setState(
                                        {

                                            or: n
                                        }
                                    )
                                }
                                return (
                                    <Table.Row >

                                        <Table.Cell>{e}</Table.Cell>
                                        <Table.Cell><Button className="btn" value="remove" onClick={remove} >remove</Button></Table.Cell>

                                    </Table.Row>
                                )
                            })}
                    </Table.Body>
                </Table>
                <button onClick={this.handleSubmit}>Submit</button>
            </div>
        )
    }
}
const logic_options = [
    { key: '==', text: '==', value: '==' },
    { key: '!=', text: '!=', value: '!=' },

]
const country_options = [
    { key: 'usa', text: 'usa', value: 'usa' },
    { key: 'europe', text: 'europe', value: 'europe' },
    { key: 'china', text: 'china', value: 'china' },

]
const juris_options = [
    { key: 'j1', text: 'j1', value: 'j1' },
    { key: 'j2', text: 'j2', value: 'j2' },
    { key: 'j3', text: 'j3', value: 'j3' }
]
const attribute_options = [
    { key: 'country', text: 'country', value: 'country' },
    { key: 'jurisdiction', text: 'jurisdiction', value: 'jurisdiction' },

]
const attribute_values =
{
    empty: [],
    country: country_options,
    jurisdiction: juris_options
};


