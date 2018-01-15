module Coinslip
  enum Currency
    BTC
  end

  macro currency_from_string(string)
    case {{string}}
    {% for currency in Currency.constants %}
    when {{currency.stringify.underscore}} then Currency::{{currency}}
    {% end %}
    end
  end

  module CurrencyJSONConverter
    def self.from_json(parser)
      string = parser.read_string
      currency = Coinslip.currency_from_string(string)
      return currency if currency
      raise JSON::ParseException.new(
        "Unsupported currency #{string}",
        parser.line_number, parser.column_number
      )
    end

    def self.to_json(currency : Currency, builder)
      {% begin %}
      case currency
      {% for currency in Currency.constants %}
      when Currency::{{currency}}
        builder.string({{currency.stringify.underscore}})
      {% end %}
      end
      {% end %}
    end
  end

  module CurrenciesYAMLConverter
    def self.from_yaml(ctx, node)
      node.raise(
        "unexpected node type #{node.class}, was expecting Sequence"
      ) unless node.is_a?(YAML::Nodes::Sequence)
      node.map do |sequence_node|
        sequence_node.raise(
          "unexpected node type #{sequence_node.class}, was expecting scalar",
        ) unless sequence_node.is_a?(YAML::Nodes::Scalar)
        currency = Coinslip.currency_from_string(sequence_node.value)
        unless currency
          sequence_node.raise("Unsupported currency #{sequence_node.value}")
        end

        currency
      end
    end
  end
end
