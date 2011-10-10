require 'cache/storage/base_storage_plugin'

class Cache::Plugins
  # This storage plugin provides a mechanism for using a file and serialization
  # as a persistent store.
  class SerializedFileStorage < Cache::Storage::BaseStoragePlugin
    metadata :author => 1
    config :filename
    
    storage_persistent true
    storage_load_all do
    end
  end
end
