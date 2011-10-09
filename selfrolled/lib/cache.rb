#!/usr/bin/env ruby

require 'yaml'
require 'thread'
require 'pp'

# This class represents a cache object.
# 
class Cache
  include Enumerable

  VERSION = 1

  # Create a new cache object
  #
  #   * options - a hash of options
  #     * file - filename to store cache data in
  #       * mandatory
  #       * should be a valid path, and writeable
  #
  def initialize(options = {})
    # storage for cache_file
    @cache_file = options[:file]

    # This is our in memory data storage hash.
    #
    # the following defaults are all that should exist at the top level,
    # to avoid collisions with versioning of the formats later on.
    #
    # Since it is going to be serialized it should not contain ruby objects 
    # or weird stuff (not sure what is weird yet).
    #
    # TODO: have a wash or validation routine that checks validatity
    @data = {
      :version => Cache::VERSION,
      :cache => {}
    }

    # semaphore to use for data access
    @data_lock = Mutex.new
  end

  # Store a value in the cache
  #
  #   * key - the key to use for storage
  #     * string only
  #     * probably needs some controls on what can be used
  #     * should have a maximum length
  #     * mandatory
  #   * data - the data to store 
  #     * if nil, clear the existing value
  #     * at the moment this is a scalar string only
  #     * mandatory
  #   * options - a hash of options
  #     * optional
  #     * :ttl - time to live in seconds
  #       * gets stored in the cache as well and is used by default for 
  #         expiry calcuation during retrieval
  #       * if nil or 0 don't cache
  #       * if -1 cache forever
  #       * otherwise only positive integers
  #
  def store(key, data, options = {})
    # TODO: validation of params & key

    # Changes to the hash keys are synchronised using a mutex
    # specific to this cache object
    @data_lock.synchronize do
      cache_data[key] = {
        :data => data,
        :stored => current_time,
        :ttl => options[:ttl]
      }
    end

    nil
  end

  # Retrieve a value from the cache
  #
  #   * key - the key to retrieve
  #   * options - a hash of params
  #     * :ttl_overide - provide a new ttl overriding the one stored 
  #       * optional - will use stored one if available
  #     *
  #
  def retrieve(key, options = {})
    # TODO: validation and defaults for options
    # TODO: validation for key

    cache_data[key][:data]
  end

  # Version
  #
  def data_version
    @data[:version]
  end

  private

  # Return the current time in consistent way
  #
  def current_time
    # TODO: check if this is timezone safe
    Time.now.to_i
  end

  # Get the internal cache storage hash
  #
  def cache_data
    @data[:cache]
  end

end
