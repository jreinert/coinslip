require "json"
require "./error"

module Coinslip
  module Api
    class ErrorResponse
      JSON.mapping(error: Api::Error)

      def initialize(@error)
      end
    end
  end
end
