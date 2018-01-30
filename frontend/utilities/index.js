import 'node-forge/lib/sha512'
import HMAC from 'node-forge/lib/hmac'

export const parseQuery = query => {
  const pairs = query.substr(1).split('&').map(pair => pair.split('='))
  return pairs.reduce(
    (result, [key, value]) =>
      ({ ...result, [decodeURIComponent(key)]: decodeURIComponent(value) }),
    {}
  )
}

export const buildQuery = (data) =>
  Object.keys(data).map(key =>
    `${encodeURIComponent(key)}=${encodeURIComponent(data[key])}`
  ).join('&')

export const sign = (secret, data) => {
  const hmac = HMAC.create()
  hmac.start('sha512', secret)
  hmac.update(data)
  return hmac.digest().toHex()
}

export const identity = (value) => value
