import { handleActions } from 'redux-actions'
import { parseQuery } from 'utilities'
import { default as actions, LOCATION_CHANGE } from 'actions'

const { redeemRequest: { update: UPDATE } } = actions

export default handleActions({
  [UPDATE]: (state, { payload: attributes }) => {
    return { ...state, ...attributes }
  },
  [LOCATION_CHANGE]: (state, { payload: { pathname, search: query } }) => {
    if (pathname !== '/redeem') return state
    const { amount, ...rest } = parseQuery(query)
    return { amount: parseFloat(amount), ...rest }
  }
}, {})
