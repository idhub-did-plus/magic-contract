import { generateStore, EventActions } from '@drizzle/store'
import drizzleOptions from './drizzleOptions'
import { put, takeEvery } from 'redux-saga/effects'


const TODOS_FETCH = 'MY_APP/TODOS_FETCH'
const TODOS_RECEIVED = 'MY_APP/TODOS_RECEIVED'

// reducers
const todosReducer = (state=2, action) => {
 if (action.type === TODOS_RECEIVED) {
   // update your state
   return action.todos
 }
 return state;
}
const appReducers = { currentMenu: todosReducer }
   const store = generateStore({
    drizzleOptions,
    appReducers,
    //appSagas,
   // appMiddlewares,
    currentMenu: 2  // enable ReduxDevTools!
   })
   
   export default store