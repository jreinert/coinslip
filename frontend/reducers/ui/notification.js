import { handleActions, combineActions } from 'redux-actions'
import { default as actions, LOCATION_CHANGE } from 'actions'

const {
  slip: { create: CREATE_SLIP },
  redeemRequest: { requestPayment: REQUEST_SLIP_PAYMENT },
  ui: { notification: { dismiss: DISMISS } }
} = actions

export default handleActions({
  [`${CREATE_SLIP}_FULFILLED`]: (state) =>
    ({ message: 'Created slip successfully', severity: 'success' }),
  [`${CREATE_SLIP}_REJECTED`]: (state) => ({
    message: 'Slip creation failed. Check log for errors',
    severity: 'danger'
  }),
  [`${REQUEST_SLIP_PAYMENT}_FULFILLED`]: (state) =>
    ({ message: 'Payment requested', severity: 'success' }),
  [`${REQUEST_SLIP_PAYMENT}_REJECTED`]: (state) => ({
    message: 'Payment request failed. Check log for errors',
    severity: 'danger'
  }),
  [combineActions(DISMISS, LOCATION_CHANGE)]: () => ({})
}, {})
