import { handleActions } from 'redux-actions'
import { buildQuery } from 'utilities'
import actions from 'actions'

const { slip: { update: UPDATE, create: CREATE } } = actions

const { location: { protocol, host } } = window

const defaultState = {
  currency: 'btc',
  amount: 0,
  baseRedeemURL: `${protocol}//${host}`,
  currencies: [
    { identifier: 'btc', label: 'Bitcoin' },
    { identifier: 'ltc', label: 'Litecoin' }
  ]
}

const generateRedeemURL = ({ baseRedeemURL, id, amount, currency, secret }) => {
  const query = buildQuery({ id, amount, currency, secret })
  return `${baseRedeemURL}#/redeem?${query}`
}

export default handleActions({
  [UPDATE]: (state, { payload: attributes }) => {
    const { redeemURL, id, secret, ...filteredState } = state
    return { ...filteredState, ...attributes }
  },
  [`${CREATE}_FULFILLED`]: (state, { payload: { id, secret } }) => {
    const { baseRedeemURL, amount, currency } = state
    const redeemURL = generateRedeemURL(
      { baseRedeemURL, id, amount, currency, secret }
    )
    return { ...state, id, secret, redeemURL }
  }
}, defaultState)
