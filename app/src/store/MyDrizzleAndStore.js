import { generateStore, EventActions } from '@drizzle/store'
import drizzleOptions from './drizzleOptions'
import {menuReducer} from "./resucers"
import { Drizzle} from '@drizzle/store'



   const appReducers = { currentMenu: menuReducer }
   const store = generateStore({
    drizzleOptions,
    appReducers,
    //appSagas,
   // appMiddlewares,
    currentMenu: 2  // enable ReduxDevTools!
   })
   var drizzle = new Drizzle(drizzleOptions, store)
   export default  drizzle;