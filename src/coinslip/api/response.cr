require "json"

module Coinslip
  module Api
    class Response(T)
      JSON.mapping(result: T)

      def initialize(@result : T)
      end
    end
  end
end
