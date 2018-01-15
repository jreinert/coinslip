require "./bad_request"

module Coinslip
  module Api
    module Errors
      class MissingRequestBody < BadRequest
        def initialize
          super("Missing request body")
        end
      end
    end
  end
end
