require "./ipfs"

module Coinslip
  class RedeemListener
    def initialize
      @ipfs = IPFS.connect
    end

    def redeem_requests
      Coinslip::REDEEM_REQUESTS
    end

    def slips
      Coinslip::SLIPS
    end

    def pay(slip, redeem_request)
      unless redeem_request.verifies_against?(slip)
        puts "Invalid redeem request"
        return
      end

      Coinslip.wallet_for(slip.currency).pay(redeem_request)
      slips.delete(slip.id)
      puts "Payed #{redeem_request.to_json}"
    end

    def start
      loop do
        @ipfs.subscribe("redeem") do |message|
          redeem_request = RedeemRequest.from_json(message.data)
          next if redeem_requests.includes?(redeem_request)
          if slip = slips[redeem_request.id]?
            pay(slip, redeem_request)
          else
            wallet = Coinslip.wallet_for(redeem_request.currency)
            wallet.subscribe(redeem_request)
            redeem_requests << redeem_request
          end
        end
      end
    end

    def self.start
      new.start
    end
  end
end
