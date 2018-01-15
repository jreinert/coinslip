require "json"
require "openssl/hmac"
require "./currency"

module Coinslip
  class RedeemRequest
    JSON.mapping(
      id: String,
      address: String,
      amount: Float64,
      currency: { type: Currency, converter: CurrencyJSONConverter },
      hmac: String,
    )

    property? payed : Bool = false

    def verifies_against?(slip)
      secret = slip.secret
      (
        amount == slip.amount &&
        currency == slip.currency &&
        secret &&
        OpenSSL::HMAC.hexdigest(:sha512, secret, address) == hmac
      )
    end
  end
end
