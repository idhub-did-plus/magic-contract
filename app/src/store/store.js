import { generateStore, EventActions } from '@drizzle/store'
import drizzleOptions from './drizzleOptions'
import {menuReducer} from "./resucers"

const appReducers = { currentMenu: menuReducer }
   const store = generateStore({
    drizzleOptions,
    appReducers,
    //appSagas,
   // appMiddlewares,
    currentMenu: 2  // enable ReduxDevTools!
   })
   
   export default store