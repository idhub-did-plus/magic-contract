
import { Drizzle} from '@drizzle/store'
import store from "./store"
import options from "./drizzleOptions"
var drizzle = new Drizzle(options, store)
export default  drizzle;

