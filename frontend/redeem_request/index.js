import { hmac } from 'forge'

const create = (address, { id, amount, currency, secret }) => {
	const digest = hmac.create()
	digest.start('sha256', secret)
	digest.update(address)
	return { id, amount, currency, address, hmac: digest.digest().toHex() }
}

export default { create }
