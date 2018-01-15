require "./ipfs"

module Coinslip
  class RedeemBroadcast
    BROADCAST_FREQUENCY = 1.minute

    def initialize
      @ipfs = IPFS.connect
    end

    def redeem_requests
      Coinslip::REDEEM_REQUESTS
    end

    def slips
      Coinslip::SLIPS
    end

    def start
      loop do
        redeem_requests.each do |id, request|
          next if request.payed?
          @ipfs.publish("redeem", request.to_json)
        end

        sleep BROADCAST_FREQUENCY
      end
    end

    def self.start
      new.start
    end
  end
end
