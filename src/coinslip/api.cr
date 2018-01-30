require "http/server"
require "baked_file_system"
require "./api/router"
require "./api/response"
require "./api/errors/missing_request_body"
require "./api/errors/json_parse_error"
require "./redeem_request"

module Coinslip
  module Api
    class CORSHandler
      include HTTP::Handler

      def call(context)
        context.response.headers.add(
          "Access-Control-Allow-Origin", "*"
        )
        call_next(context)
      end
    end

    class AssetHandler
      include HTTP::Handler
      CACHE_CONTROL = "public, max-age=31536000"

      class Storage
        BakedFileSystem.load("../../public")
      end

      def call(context)
        path = context.request.path
        path = "/index.html" if path =~ /^\/?$/
        file = Storage.get(path)
        response = context.response
        response.content_type = file.mime_type
        response.headers["Cache-Control"] = CACHE_CONTROL
        IO.copy(file, context.response)
      rescue BakedFileSystem::NoSuchFileError
        call_next(context)
      end
    end

    ROUTER = Router.configure do |routes|
      routes.post "/api/slips" do |context|
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

      routes.post "/api/slips/redeem" do |context|
        body = context.request.body
        raise Errors::MissingRequestBody.new unless body
        begin
          redeem_request = RedeemRequest.from_json(body)
          context.response.status_code = 204
          next if redeem_requests.includes?(redeem_request)
          Coinslip.wallet_for(redeem_request.currency).subscribe(redeem_request)
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
      handlers = [
        HTTP::LogHandler.new, CORSHandler.new, AssetHandler.new, ROUTER
      ]
      HTTP::Server.new(host, port, handlers)
    end
  end
end
