import { combineReducers } from 'redux'
import { routerReducer as router } from 'react-router-redux'
import slip from './slip'
import redeemRequest from './redeem-request'
import ui from './ui'

export default combineReducers({ slip, redeemRequest, ui, router })
