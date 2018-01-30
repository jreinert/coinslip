require "yaml"
require "./currency"

module Coinslip
  class Config
    YAML.mapping(
      slip_storage_path: {
        type: String,
        default: File.join(
          ENV.fetch("XDG_DATA_HOME", File.join(ENV["HOME"], ".local", "share")),
          "coinslip",
          "slips.json"
        )
      },
      redeem_request_storage_path: {
        type: String,
        default: File.join(
          ENV.fetch("XDG_DATA_HOME", File.join(ENV["HOME"], ".local", "share")),
          "coinslip",
          "redeem_requests.json"
        )
      },
      api_host: { type: String, default: "localhost" },
      api_port: { type: Int32, default: 3322 },
      expose_errors: { type: Bool, default: false },
      ipfs_host: { type: String, default: "localhost" },
      ipfs_port: { type: Int32, default: 5001 },
      currencies: {
        type: Array(Currency),
        converter: CurrenciesYAMLConverter,
        default: [Currency::BTC]
      }
    )

    @@instance : self?

    def self.load(path)
      unless File.exists?(path)
        return @@instance = from_yaml("---\n")
      end

      File.open(path) do |file|
        @@instance = from_yaml(file)
      end
    end

    def self.instance
      @@instance || raise("Config hasn't been loaded")
    end
  end
end
