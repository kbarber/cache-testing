require 'cache/base_plugin'

class Cache::Storage
  class BaseStoragePlugin < Cache::BasePlugin
    def self.storage_persistent(bool)
      @persistent = bool
    end

    def self.storage_load_all(&block)
      @load_all = block
    end

    def self.storage_retrieve(&block)
      @retrieve = block
    end

    def self.storage_store(&block)
      @retrieve = block
    end
  end
end
