export const LOGIN = 'LOGIN'
export const LOGIN_FINISHED = 'LOGIN_FINISHED'
export function login(payload) {
    return { type: LOGIN, payload };
}
export function loginFinished(payload) {
    return { type: LOGIN_FINISHED, payload };
}
