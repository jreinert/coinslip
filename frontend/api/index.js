import 'whatwg-fetch'
import { sign, identity } from 'utilities'

const errorMessage = ({ message, detail }) =>
  [message, detail].filter(identity).join(' - ')

const request = (path, payload) =>
  fetch(API_URL + path, { method: 'POST', body: JSON.stringify(payload) })
    .then(response => response.json())
    .then(({ result, error }) => {
      if (error) throw new Error(errorMessage(error))
      else return result
    })

export const redeem = (attributes) => {
  const { secret, address } = attributes
  const hmac = sign(secret, address)
  return request('/slips/redeem', { ...attributes, hmac })
}

export const create = (attributes) =>
  request('/slips', attributes)
