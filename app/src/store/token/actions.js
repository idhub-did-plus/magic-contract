export const DEPLOY_1400 = 'DEPLOY/1400'
export const DEPLOY_FINISHED_1400 = 'DEPLOY/FINISHED1400'
export const TOKENS_LOADED = 'TOKENS_LOADED'
export function deployFinished1400(payload) {
    return { type: DEPLOY_FINISHED_1400, payload };
}
export function deploy1400(payload) {
    return { type: DEPLOY_1400, payload };
}
export function tokenLoaded(payload) {
    return { type: TOKENS_LOADED, payload };
}