require "./bad_request"

module Coinslip
  module Api
    module Errors
      class JSONParseError < BadRequest
        def initialize(error : JSON::ParseException)
          super(error.class.name, error.message)
        end
      end
    end
  end
end
