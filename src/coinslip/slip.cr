require "json"
require "uuid"
require "./currency"

module Coinslip
  class Slip
    JSON.mapping(
      id: { type: String, default: generate_id },
      secret: { type: String?, default: generate_secret },
      amount: Float64,
      currency: { type: Currency, converter: CurrencyJSONConverter }
    )

    def initialize(@id, @amount, @currency)
    end

    def public
      self.class.new(id, amount, currency)
    end

    private def generate_id
      UUID.random.to_s
    end

    private def generate_secret
      Random::Secure.hex
    end
  end
end
