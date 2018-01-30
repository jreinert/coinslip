import { createActions } from 'redux-actions'
import SLIP from './slip'
import UI from './ui'
import REDEEM_REQUEST from './redeem-request'

export const LOCATION_CHANGE = '@@router/LOCATION_CHANGE'
export default createActions({ SLIP, REDEEM_REQUEST, UI })
