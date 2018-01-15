require "./config"
require "./redeem_request"

module Coinslip
  class BlockchainListener
    QUERY_FREQUENCY = 1.minute

    def self.start
      new.start
    end

    def listen(currency)
      wallet = Coinslip.wallet_for(currency)
      loop do
        Coinslip::REDEEM_REQUESTS.each do |id, request|
          next unless wallet.payed?(request)
          request.payed = true
        end

        sleep QUERY_FREQUENCY
      end
    end

    def start
      Config.instance.currencies.each do |currency|
        spawn { listen(currency) }
      end
    end
  end
end
