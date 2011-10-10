class Cache
  # This class manages plugins for Cache
  class Plugins

    # This initializes all plugins in the cache/plugins directory
    # loading them up and finding out their capabilities
    def initialize
      # First require all plugins
      @plugins = require_plugins
    end

    # Return an array of loaded plugins
    def get_plugins
      @plugins
    end

    private

    def require_plugins
      $:.each do |libdir|
        Dir.glob("#{libdir}/cache/plugins/*.rb").each do |plugin|
          require plugin
        end
      end

      # Iterate across the plugin constants and find plugins
      valid_plugins = []
      Cache::Plugins.constants.each do |const|
        const_obj = Cache::Plugins.const_get(const)

        # Check if its a plugin
        if valid_plugin?(const_obj)
          valid_plugins << const_obj
        end

      end

      valid_plugins
    end

    def valid_plugin?(obj)
      obj.ancestors.include?(Cache::BasePlugin)
    end

  end
end
