import React, { Component } from "react";
import ContractData from "../contract/ContractData";
import ContractForm from "../contract/ContractForm";
import ContractDataForm from "../contract/ContractDataForm";
import { BrowserRouter as Router, NavLink, Link, Route, Switch, useParams, useRouteMatch } from "react-router-dom";

import { DrizzleContext } from "@drizzle/react-plugin";

export default function TokenStatisticsComponent(props) {

  return (
    <div className="mysection">
      <h2>ComplianceConfiguration: </h2>
      <p>
        A place to configure the claim logic for token which use ConfigurableComplianceService
</p>

    </div>
  )
}
