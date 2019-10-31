
import {LOGIN, LOGIN_FINISHED} from "./actions"
import { put, takeEvery } from 'redux-saga/effects'

// fetch data from service using sagas
function *login() {
   const payload = yield  new Promise((resolve, reject) => {
    let wait = setTimeout(() => {
     
      resolve(true);
    }, 2000)
  })
   .then(resp => resp)
  
   yield put({ type: LOGIN_FINISHED,  payload})
  }

  function *loginSaga() {
   yield takeEvery(LOGIN, login)
  }

export default  loginSaga;