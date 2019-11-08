import { generateStore, Drizzle, EventActions } from '@drizzle/store'
import drizzleOptions from './drizzleOptions'
import loginReducer from "./login/reducers"
import loginSaga from "./login/saga"
import tokenReducer from "./token/reducers"
import tokenSaga from "./token/saga"
const contractEventNotifier = store => next => action => {
   if (action.type === EventActions.EVENT_FIRED) {
     const contract = action.name
     const contractEvent = action.event.event
     const contractMessage = action.event.returnValues._message
     const display = `${contract}(${contractEvent}): ${contractMessage}`
  
     // interact with your service
     console.log('Contract event fired', display)
   }
   return next(action)
  }

  const appMiddlewares = [ contractEventNotifier ]
  const appSagas = [loginSaga,tokenSaga]

   const appReducers = { login: loginReducer, deployedTokens: tokenReducer }
   const store = generateStore({
    drizzleOptions,
    appReducers,
    appSagas,
    appMiddlewares,
    currentMenu: 2  // enable ReduxDevTools!
   })
   var drizzle = new Drizzle(drizzleOptions, store)
   export default  drizzle;