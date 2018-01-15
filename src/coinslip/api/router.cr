require "radix"
require "http/server"
require "./error_response"
require "./errors/internal_server_error"
require "../ext/http/request"

module Coinslip
  module Api
    class Router
      include HTTP::Handler

      alias Action = ::Proc(HTTP::Server::Context, Hash(String, String), Nil)
      @routes : Radix::Tree(Action)

      def initialize
        @routes = Radix::Tree(Action).new
      end

      {% for method in %w(get post) %}
        def {{method.id}}(path, &action : HTTP::Handler::Proc)
          add_route({{method}}, path) do |context, url_params|
            context.request.url_params = url_params
            handle_errors(context) { action.call(context) }
          end

          {% if method == "get" %}
            add_route("head", path) {}
          {% end %}
        end
      {% end %}

      def call(context)
        request = context.request
        result = @routes.find("/#{request.method.downcase}/#{request.path}")
        return call_next(context) unless result.found?
        result.payload.call(context, result.params)
      end

      def self.configure
        new.tap { |router| yield(router) }
      end

      private def handle_errors(context)
        yield
      rescue api_error : Api::Error
        respond_with_error(context, api_error)
      rescue general_error
        api_error = Api::Errors::InternalServerError.new(general_error)
        respond_with_error(context, api_error)
      end

      private def respond_with_error(context, error)
        context.response.status_code = error.status_code
        ErrorResponse.new(error).to_json(context.response)
      end

      private def add_route(method, path, &action : Action)
        @routes.add("/#{method.downcase}/#{path}", action)
      end
    end
  end
end
