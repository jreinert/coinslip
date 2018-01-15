require "../error"
require "../../config"

module Coinslip
  module Api
    module Errors
      class InternalServerError < Error
        def initialize(exception : Exception)
          @status_code = 500
          @type = self.class.name

          if Config.instance.expose_errors
            @message = exception.class.name
            @detail = exception.message
            @trace = exception.backtrace
          end
        end
      end
    end
  end
end
