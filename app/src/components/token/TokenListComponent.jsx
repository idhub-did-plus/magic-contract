import React, { Component } from "react";
import { Table } from 'semantic-ui-react';
import { DrizzleContext } from "@drizzle/react-plugin";

class TokenListComponent extends Component {
  constructor(props) {
    super(props);

    this.handleInputChange = this.handleInputChange.bind(this);

  }
 
  handleInputChange(event) {

    const value =
      event.target.key;
      this.props.select(value) 

  }
 
  render() {

    return (
      <div >
        {/* <table class="table">
          <thead>
            <tr>
              <th>name</th>
              <th>symbol</th>
              <th>decimal</th>
              <th>controllers</th>
              <th>registryService</th>
              <th>contractAddess</th>
              <th>deployAccount</th>
            </tr>
          </thead>
          <tbody>
          {this.props.drizzleState.deployedTokens.map(el =>{
                    const select = ()=>{
                        if(this.props.select!=undefined)
                            this.props.select(el.contractAddress) 
                    }
             return  (<tr>
              <td>{el.name}</td>
              <td>{el.symbol}</td>
              <td>{el.decimal}</td>
              <td>{el.controllers}</td>
              <td>{el.registryService}</td>
              <td>{el.contractAddess}</td>
              <td>{el.deployAccount}</td>
            </tr>)
            })}
          </tbody>
        </table> */}
        <Table fixed style={{marginBottom:'20px'}}>
          <Table.Header>
            <Table.Row>
              <Table.HeaderCell>name</Table.HeaderCell>
              <Table.HeaderCell>symbol</Table.HeaderCell>
              <Table.HeaderCell>decimal</Table.HeaderCell>
              <Table.HeaderCell>controllers</Table.HeaderCell>
              <Table.HeaderCell>registryService</Table.HeaderCell>
              <Table.HeaderCell>contractAddess</Table.HeaderCell>
              <Table.HeaderCell>deployAccount</Table.HeaderCell>
            </Table.Row>
          </Table.Header>

          <Table.Body>
            {this.props.drizzleState.deployedTokens.map((el,index) =>{
                    const select = ()=>{
                        if(this.props.select!=undefined)
                            this.props.select(el.contractAddress) 
                    }
             return  (<Table.Row  onClick={select} key={index}>
                <Table.Cell>{el.name}</Table.Cell>
                <Table.Cell>{el.symbol}</Table.Cell>
                <Table.Cell>{el.decimals.toString()}</Table.Cell>
                <Table.Cell>{el.controllers.toString()}</Table.Cell>
                <Table.Cell>{el.registryAddress}</Table.Cell>
                <Table.Cell>{el.contractAddress}</Table.Cell>
                <Table.Cell>{el.deployAccount.toString()}</Table.Cell>
              </Table.Row>)
            })}
          </Table.Body>
        </Table>


      </div>
    )
  }
}

export default (props) => {
  return (
    <DrizzleContext.Consumer>
      {drizzleContext => {
        return (
          <TokenListComponent {...drizzleContext} {...props} />
        );
      }}
    </DrizzleContext.Consumer>

  )
}