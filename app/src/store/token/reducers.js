
import {DEPLOY_FINISHED_1400} from "./actions"
const initialState =  []
const deployReducer = (state=initialState, action) => {
    if (action.type === DEPLOY_FINISHED_1400) {
      let deployedTokens = state;
      return  [...deployedTokens,  action.payload];
    }
    return state;
   }
   export default deployReducer;