require "http/server"
require "./api/router"
require "./api/response"
require "./api/errors/missing_request_body"
require "./api/errors/json_parse_error"
require "./redeem_request"

module Coinslip
  module Api
    ROUTER = Router.configure do |routes|
      routes.post "/slips" do |context|
        body = context.request.body
        raise Errors::MissingRequestBody.new unless body
        begin
          slip = Slip.from_json(body)
          slips << slip
          Response.new(slip).to_json(context.response)
        rescue parse_error : JSON::ParseException
          raise Errors::JSONParseError.new(parse_error)
        end
      end

      routes.post "/slips/redeem" do |context|
        body = context.request.body
        raise Errors::MissingRequestBody.new unless body
        begin
          redeem_request = RedeemRequest.from_json(body)
          redeem_requests << redeem_request
          context.response.status_code = 204
        rescue parse_error : JSON::ParseException
          raise Errors::JSONParseError.new(parse_error)
        end
      end
    end

    def self.slips
      Coinslip::SLIPS
    end

    def self.redeem_requests
      Coinslip::REDEEM_REQUESTS
    end

    def self.server
      host = Config.instance.api_host
      port = Config.instance.api_port
      HTTP::Server.new(host, port, ROUTER)
    end
  end
end
