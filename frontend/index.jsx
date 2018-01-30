import 'babel-polyfill'
import 'whatwg-fetch'
import React from 'react'
import ReactDOM from 'react-dom'
import promiseMiddleware from 'redux-promise-middleware'
import { createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import App from 'components/app'
import reducer from 'reducers'
import { ConnectedRouter, routerMiddleware } from 'react-router-redux'
import { createHashHistory as createHistory } from 'history'
import { composeWithDevTools } from 'redux-devtools-extension'

const history = createHistory()
const store = createStore(
  reducer,
  composeWithDevTools(
    applyMiddleware(promiseMiddleware(), routerMiddleware(history))
  )
)

ReactDOM.render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <App/>
    </ConnectedRouter>
  </Provider>,
  document.getElementById('app')
)
