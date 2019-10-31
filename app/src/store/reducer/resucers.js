
import {CHOOSEMENU} from "../action/actions"
export const menuReducer = (state=2, action) => {
    if (action.type === CHOOSEMENU) {
      // update your state
      return action.payload;
    }
    return state;
   }