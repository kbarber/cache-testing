require 'cache/storage/base_storage_plugin'

class Cache::Plugins
  class MemoryStorage < Cache::Storage::BaseStoragePlugin
    metadata :author => 1

    storage_persistent false

    storage_load_all do
    end

    storage_retrieve do
    end

    storage_store do
    end
  end
end
