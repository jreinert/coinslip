require "json"

module Coinslip
  module Api
    abstract class Error < Exception
      JSON.mapping(
        status_code: Int32,
        type: String,
        message: String?,
        detail: String?,
        trace: Array(String)?,
      )
    end
  end
end
