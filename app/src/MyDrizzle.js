
import { Drizzle} from '@drizzle/store'
import store from "./store/store"
import options from "./store/drizzleOptions"
var drizzle = new Drizzle(options, store)
export default  drizzle;

