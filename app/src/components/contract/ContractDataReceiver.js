import React, { Component } from "react";
import PropTypes from "prop-types";

class ContractDataReceiver extends Component {
  constructor(props) {
    super(props);

    this.contracts = props.drizzle.contracts;
  
  }

  render() {
    const { drizzle, drizzleState } = this.props;

    // Contract is not yet intialized.
    if (!drizzleState.contracts[this.props.contract].initialized) {
      return <span>Initializing...</span>;
    }

    // If the cache key we received earlier isn't in the store yet; the initial value is still being fetched.
    if (
      !(
        this.props.dataKey in
        drizzleState.contracts[this.props.contract][this.props.method]
      )
    ) {
      return <span>Fetching...</span>;
    }

    // Show a loading spinner for future updates.
    var pendingSpinner = drizzleState.contracts[this.props.contract].synced
      ? ""
      : " ...";

    // Optionally hide loading spinner (EX: ERC20 token symbol).
    if (this.props.hideIndicator) {
      pendingSpinner = "";
    }

    var displayData =
      drizzleState.contracts[this.props.contract][this.props.method][
        this.props.dataKey
      ].value;
    if(displayData === null){
        return <li >
            empty result!
      </li>
    }
    // Optionally convert to UTF8
    if (this.props.toUtf8) {
      displayData = drizzle.web3.utils.hexToUtf8(displayData);
    }

    // Optionally convert to Ascii
    if (this.props.toAscii) {
      displayData = drizzle.web3.utils.hexToAscii(displayData);
    }

    // If a render prop is given, have displayData rendered from that component
    if (this.props.render) {
      return this.props.render(displayData);
    }

    // If return value is an array
    if (Array.isArray(displayData)) {
      const displayListItems = displayData.map((datum, index) => {
        return (
          <li key={index}>
            {datum}
            {pendingSpinner}
          </li>
        );
      });

      return <ul>{displayListItems}</ul>;
    }

    // If retun value is an object
    if (typeof displayData === "object") {
      var i = 0;
      const displayObjectProps = [];

      Object.keys(displayData).forEach(key => {
        if (i != key) {
          displayObjectProps.push(
            <li key={i}>
              <strong>{key}</strong>
              {pendingSpinner}
              <br />
              {displayData[key]}
            </li>,
          );
        }

        i++;
      });

      return <ul>{displayObjectProps}</ul>;
    }

    return (
      <span>
        {displayData}
        {pendingSpinner}
      </span>
    );
  }
}

ContractDataReceiver.propTypes = {
  drizzle: PropTypes.object.isRequired,
  drizzleState: PropTypes.object.isRequired,
  contract: PropTypes.string.isRequired,
  method: PropTypes.string.isRequired,
  methodArgs: PropTypes.array,
  hideIndicator: PropTypes.bool,
  toUtf8: PropTypes.bool,
  toAscii: PropTypes.bool,
  render: PropTypes.func,
};

export default ContractDataReceiver;
