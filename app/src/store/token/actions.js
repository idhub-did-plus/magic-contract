export const DEPLOY_1400 = 'DEPLY/1400'
export const DEPLOY_FINISHED_1400 = 'DEPLY/FINISHED1400'

export function deployFinished1400(payload) {
    return { type: DEPLOY_FINISHED_1400, payload };
}
export function deploy1400(payload) {
    return { type: DEPLOY_1400, payload };
}