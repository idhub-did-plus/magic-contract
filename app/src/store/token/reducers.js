
import {DEPLOY_FINISHED_1400, TOKENS_LOADED} from "./actions"
const initialState =  []
const deployReducer = (state=initialState, action) => {
    if (action.type === DEPLOY_FINISHED_1400) {
      let deployedTokens = state;
      return  [...deployedTokens,  action.payload];
    }
    if (action.type === TOKENS_LOADED) {
      let deployedTokens = action.payload.data;
      return  deployedTokens;
    }
    return state;
   }
   export default deployReducer;