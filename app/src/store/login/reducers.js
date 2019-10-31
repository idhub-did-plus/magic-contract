
import {LOGIN_FINISHED} from "./actions"
const loginReducer = (state={}, action) => {
    if (action.type === LOGIN_FINISHED) {
      // update your state
      return action.payload;
    }
    return state;
   }
   export default loginReducer;