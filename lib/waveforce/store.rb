require 'pstore'

module WaveForce
  class Store
    def initialize(path)
      @db = PStore.new(path)
    end

    def save(key, value)
      @db.transaction do
        @db[key] = value
      end
    end

    def get(key)
      @db.transaction(true) do
        @db[key]
      end
    end
  end
end