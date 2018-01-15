require "http/client"
require "json"
require "./config"

module Coinslip
  class IPFS
    BASE_PATH = "/api/v0"
    BASE_TOPIC = "coinslip"

    class Error < Exception
    end

    module Base64Converter
      def self.from_json(parser)
        Base64.decode_string(parser.read_string)
      end
    end

    class ErrorResponse
      JSON.mapping(message: { key: "Message", type: String })
    end

    class Message
      JSON.mapping(
        from: String,
        data: { type: String, converter: Base64Converter },
        seqno: String,
        topic_ids: { key: "topicIDs", type: Array(String) }
      )
    end

    def initialize(host, port)
      @client = HTTP::Client.new(host, port)
    end

    def publish(topic, payload)
      query = HTTP::Params.build do |params|
        params.add("arg", "#{BASE_TOPIC}/#{topic}")
        params.add("arg", payload)
      end

      request("/pubsub/pub?#{query}")
    end

    def subscribe(topic)
      query = HTTP::Params.build do |params|
        params.add("arg", "#{BASE_TOPIC}/#{topic}")
      end

      request("/pubsub/sub?#{query}") do |response|
        body = response.body_io
        body.gets # first line is an empty object
        while line = body.gets
          yield(Message.from_json(line))
        end
      end
    end

    private def request(path)
      response = @client.get("#{BASE_PATH}#{path}")

      unless response.success?
        error_response = ErrorResponse.from_json(response.body_io.not_nil!)
        raise Error.new(error_response.message)
      end

      response
    end

    private def request(path)
      @client.get("#{BASE_PATH}#{path}") do |response|
        unless response.success?
          error_response = ErrorResponse.from_json(response.body_io.not_nil!)
          raise Error.new(error_response.message)
        end

        yield response
      end
    end

    def self.connect
      host = Config.instance.ipfs_host
      port = Config.instance.ipfs_port
      new(host, port)
    end
  end
end
