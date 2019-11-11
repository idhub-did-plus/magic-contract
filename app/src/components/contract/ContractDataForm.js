import React, { Component } from "react";
import { Button } from 'semantic-ui-react'
import PropTypes from "prop-types";
import ContractDataReceiver from "./ContractDataReceiver"
import { DrizzleContext } from "@drizzle/react-plugin";
const translateType = type => {
  switch (true) {
    case /^uint/.test(type):
      return "number";
    case /^string/.test(type) || /^bytes/.test(type):
      return "text";
    case /^bool/.test(type):
      return "checkbox";
    default:
      return "text";
  }
};

class ContractDataForm extends Component {
  constructor(props) {
    super(props);

    this.handleInputChange = this.handleInputChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);

    this.contracts = props.drizzle.contracts;
    this.utils = props.drizzle.web3.utils;

    // Get the contract ABI
    const abi = this.contracts[this.props.contract].abi;

    this.inputs = [];
    var initialState = { dataKey: null };

    // Iterate over abi for correct function.
    for (var i = 0; i < abi.length; i++) {
      if (abi[i].name === this.props.method) {
        this.inputs = abi[i].inputs;

        for (var j = 0; j < this.inputs.length; j++) {
          initialState[this.inputs[j].name] = "";
        }

        break;
      }
    }

    this.state = initialState;
  }

  handleSubmit(event) {
    event.preventDefault();
    try {
      const convertedInputs = this.inputs.map(input => {
        if (input.type === "bytes32") {
          return this.utils.toHex(this.state[input.name]);
        }
        if (input.type === "address") {
          if (!this.utils.isAddress(this.state[input.name])) {

            throw new Error("not an address");
          }

        }
        return this.state[input.name];
      });

      if (this.props.sendArgs) {
        let method = this.contracts[this.props.contract].methods[this.props.method];
        return method.cacheSend(...convertedInputs, this.props.sendArgs);
      }

      let method = this.contracts[this.props.contract].methods[this.props.method];
      let dataKey = method.cacheSend(...convertedInputs);


      this.setState({ ...this.state, dataKey: dataKey });
      return dataKey;
    } catch (err) {
      alert(err)

    }
  }

  handleInputChange(event) {
    const value =
      event.target.type === "checkbox"
        ? event.target.checked
        : event.target.value;
    this.setState({ ...this.state, [event.target.name]: value });
  }

  render() {
    if (this.props.render) {
      return this.props.render({
        inputs: this.inputs,
        inputTypes: this.inputs.map(input => translateType(input.type)),
        state: this.state,
        handleInputChange: this.handleInputChange,
        handleSubmit: this.handleSubmit,
      });
    }

    return (
      <div>

        <form
          className="pure-form pure-form-stacked"
          onSubmit={this.handleSubmit}
        >
          {this.inputs.map((input, index) => {
            var inputType = translateType(input.type);
            var inputLabel = this.props.labels
              ? this.props.labels[index]
              : input.name;
            // check if input type is struct and if so loop out struct fields as well
            return (
              <input
                key={input.name}
                type={inputType}
                name={input.name}
                value={this.state[input.name]}
                placeholder={inputLabel}
                onChange={this.handleInputChange}
              />
            );
          })}
          {/* <Button 
          key="submit"
          onClick={this.handleSubmit}
        >
          Fetch
        </Button> */}
          <ContractDataReceiver {...this.props} dataKey={this.state.dataKey} />
          <br />
          <button
            key="submit"
            onClick={this.handleSubmit}
          >Fetch</button>
        </form>

      </div>
    );
  }
}

ContractDataForm.propTypes = {
  drizzle: PropTypes.object.isRequired,
  contract: PropTypes.string.isRequired,
  method: PropTypes.string.isRequired,
  sendArgs: PropTypes.object,
  labels: PropTypes.arrayOf(PropTypes.string),
  render: PropTypes.func,
};

export default (props) => {
  return (
    <DrizzleContext.Consumer>
      {drizzleContext => {
        return (
          <ContractDataForm {...drizzleContext} {...props} />
        );
      }}
    </DrizzleContext.Consumer>

  )
}

