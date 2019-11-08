
import { DEPLOY_1400, deployFinished1400 } from "./actions"
import { put, takeEvery } from 'redux-saga/effects'
import drizzle from '../MyDrizzleAndStore'
import ERC1400 from "../../contracts/ERC1400.json";
const contract = require("@truffle/contract");
const MyContract = contract(ERC1400)
function* deploy(payload) {

  let utils = drizzle.web3.utils;
  let web3 = drizzle.web3;
  MyContract.setProvider(web3.currentProvider);

   let inst = yield MyContract.new(
    payload.name,
    payload.symbol,
    utils.toBN(payload.decimals),
    payload.controllers,
    payload.registryAddress, { from: drizzle.state.accounts[0] });
  let pl = {
    ...payload,
    contractAddress: inst.address,
    deployAccount: drizzle.state.accounts[0]
  };


  yield put(deployFinished1400(pl))
}

function* deploy1400Saga() {
  yield takeEvery(DEPLOY_1400, deploy)
}

export default deploy1400Saga;