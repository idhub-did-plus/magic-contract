import { generateStore, Drizzle, EventActions } from '@drizzle/store'
import drizzleOptions from './drizzleOptions'
import {menuReducer} from "./resucers"
import {} from "./actions"
import { put, takeEvery } from 'redux-saga/effects'

const TODOS_FETCH = 'MY_APP/TODOS_FETCH'
const TODOS_RECEIVED = 'MY_APP/TODOS_RECEIVED'
// fetch data from service using sagas
function *fetchTodos() {
   const todos = yield fetch('https://jsonplaceholder.typicode.com/todos')
   .then(resp => resp.json())
   yield put({ type: TODOS_RECEIVED, todos })
  }
  // app root saga
  function *appRootSaga() {
   yield takeEvery(TODOS_FETCH, fetchTodos)
  }

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
  const appSagas = [appRootSaga]

   const appReducers = { currentMenu: menuReducer }
   const store = generateStore({
    drizzleOptions,
    appReducers,
    appSagas,
    appMiddlewares,
    currentMenu: 2  // enable ReduxDevTools!
   })
   var drizzle = new Drizzle(drizzleOptions, store)
   export default  drizzle;