require "../error"

module Coinslip
  module Api
    module Errors
      class BadRequest < Error
        def initialize(@message, @detail = nil)
          @type = self.class.name
          @status_code = 400
        end
      end
    end
  end
end
