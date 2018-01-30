require "http/client"
require "bitcoin"
require "json"
require "../wallet"
require "../currency"

module Coinslip
  module Wallets
    class BTC < Wallet
      alias PaymentCategory = Bitcoin::RPC::Payment::Category

      class Error < Exception
      end

      @@instance : self?

      def initialize(rpc_password, host, port)
        @client = Bitcoin::Client.new(rpc_password, host, port)
        @@instance = self
      end

      def self.instance
        @@instance || raise Error.new("Uninitialized wallet")
      end

      def pay(redeem_request)
        @client.send_to(redeem_request.address, redeem_request.amount)
      end

      def payed?(redeem_request)
        unless redeem_request.currency == Currency::BTC
          raise Error.new("Unsupported currency #{redeem_request.currency}")
        end

        transactions = @client.list_transactions(redeem_request.id)
        return false unless transactions
        transactions.any? do |transaction|
          transaction.category == PaymentCategory::Receive &&
            transaction.amount == redeem_request.amount
        end
      end

      def subscribe(redeem_request)
        unless redeem_request.currency == Currency::BTC
          raise Error.new("Unsupported currency #{redeem_request.currency}")
        end

        puts @client.import_address(
          redeem_request.address, redeem_request.id, true
        )
      end

      private macro request(response_type, method, *params)
        response = @client.post("/", body: RPC.new({{method}}, {{*params}}).to_json)
        body = response.body_io
        raise Error.new("Missing body") unless body
        RPCResponse({{response_type}}).from_json(body)
      end
    end
  end
end
