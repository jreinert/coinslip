import { handleActions } from 'redux-actions'
import actions from 'actions'
const { slip: { create: CREATE_SLIP }, ui: { modal: { hide: HIDE } } } = actions

const defaultState = {
  show: false
}

export default handleActions({
  [`${CREATE_SLIP}_FULFILLED`]: () => ({ show: true }),
  [HIDE]: () => ({ show: false })
}, defaultState)
