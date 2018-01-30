require "json"
require "./config"

module Coinslip
  class Storage(T)
    def initialize(@save_path : String, @container : Hash(String, T))
      @mutex = Channel(Bool).new(1)
      @mutex.send(true)
    end

    def <<(item)
      synchronize do
        return if @container.has_key?(item.id)
        @container[item.id] = item
        save
      end
    end

    def includes?(item)
      synchronize do
        @container.has_key?(item.id)
      end
    end

    def delete(id)
      synchronize do
        @container.delete(id)
        save
      end
    end

    def [](id)
      synchronize { @container[id] }
    end

    def []?(id)
      synchronize { @container[id]? }
    end

    def each
      synchronize { @container.each { |id, item| yield(id, item) } }
    end

    def self.load(path)
      unless File.exists?(path)
        return new(path, {} of String => T)
      end

      File.open(path) do |file|
        new(path, Hash(String, T).from_json(file))
      end
    end

    private def save
      File.open(@save_path, "w+") do |file|
        @container.to_json(file)
      end
    end

    private def synchronize
      @mutex.receive
      yield
    ensure
      @mutex.send(true)
    end
  end
end
