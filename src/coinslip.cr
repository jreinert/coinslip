require "option_parser"
require "./coinslip/*"
require "./coinslip/wallets/*"

module Coinslip
  config_path = File.join(
    ENV.fetch("XDG_CONFIG_HOME", File.join(ENV["HOME"], ".config")),
    "coinslip", "config.yml"
  )

  initial_parser = OptionParser.new do |parser|
    parser.on("-c PATH", "--config=PATH") do |path|
      config_path = path
    end
    parser.invalid_option {}
  end

  initial_parser.parse(ARGV)
  Config.load(config_path)

  option_parser = OptionParser.new do |parser|
    parser.banner = "Usage: #{PROGRAM_NAME} [options]"

    parser.on("-c PATH", "--config=PATH", "Use given PATH for config") {}
    parser.on("-e", "--expose-errors", "Expose internal server errors") do
      Config.instance.expose_errors = true
    end

    parser.on("-h", "--help", "Show this message") do
      puts parser
      exit
    end
  end

  option_parser.parse(ARGV)
  Dir.mkdir_p(File.dirname(Config.instance.slip_storage_path))
  Dir.mkdir_p(File.dirname(Config.instance.redeem_request_storage_path))

  REDEEM_REQUESTS = Storage(RedeemRequest).load(
    Config.instance.redeem_request_storage_path
  )
  SLIPS = Storage(Slip).load(
    Config.instance.slip_storage_path
  )

  Wallets::BTC.new("NobVasBoyzPoahujDoijnawyatgidd", "localhost", 18332)

  def self.wallet_for(currency : Currency)
    {% begin %}
    case currency
    {% for constant in Currency.constants %}
    when Currency::{{constant}} then Wallets::{{constant}}.instance
    {% end %}
    else raise "Unsupported currency: #{currency}"
    end
    {% end %}
  end

  spawn { Api.server.listen }
  spawn { RedeemBroadcast.start }
  spawn { RedeemListener.start }
  spawn { BlockchainListener.start }

  sleep
end
