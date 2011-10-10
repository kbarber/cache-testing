class Cache
  class BasePlugin

    def initialize
      raise Cache::PluginInterface("You must override the initialize method for this     plugin")
    end

    def self.base_plugin
      self.superclass
    end

    # Set metadata
    def self.metadata(md)
      @@metadata = md
    end

    # Get metadata
    def self.get_metadata
      @@metadata
    end

    # Set config
    def self.config(conf)
      @config = conf
    end
  end
end
