#!/usr/bin/env ruby

require 'yaml'
require 'thread'
require 'pp'
require 'cache/exceptions'
require 'cache/plugins'

# This class represents a cache object.
# 
class Cache
  include Enumerable

  API_VERSION = 1

  # Create a new cache object
  #
  #   * options - a hash of options
  #     * file - filename to store cache data in
  #       * mandatory
  #       * should be a valid path, and writeable
  #     * default_ttl - the default ttl to apply to all entries if not otherwise
  #                     specified
  #       * optional
  #       * should be a valid ttl
  #
  def initialize(options = {})
    # TODO: validate options

    # Check mandatory options
    [:file].each do |opt|
      unless options.include?(opt)
        raise Cache::ParameterException.new("The :#{opt} option is a mandatory option during creation of a Cache object")
      end
    end

    # Store passed options
    @options = options

    # Default TTL is 0 by default to disable caching unless asked
    @options[:default_ttl] ||= 0

    # Load plugins: best do this after validation
    load_plugins

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
      :version => VERSION,
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
  #       * default is 0
  #
  def store(key, data, options = {})
    # TODO: validation of params & key

    # Set some defaults

    # Configure the :ttl option to align with the cache objects 
    # :default_ttl if :ttl is not provided.
    options[:ttl] ||= cache_options[:default_ttl]
    options[:time_updated] ||= current_time

    # Changes to the hash keys are synchronised using a mutex
    # specific to this cache object
    @data_lock.synchronize do
      cache_data[key] = {
        :data => data,
        :time_updated => options[:time_updated],
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
    # TODO: validate key
    # TODO: validation and defaults for options
    # TODO: validation for key

    # First check if the key exists and raise an exception if it does not
    unless entry_exists?(key)
      raise Cache::EntryMissing.new("The entry #{key} cannot be found in the internal cache data store")
    end

    if entry_expired?(cache_data[key][:time_updated], cache_data[key][:ttl])
      raise Cache::EntryExpired.new("The entry #{key} has expired")
    end

    cache_data[key][:data]
  end

  # Return the options set for this object
  #
  def cache_options
    @options
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

  # Using the epoch as the creation time, ttl as the time to live
  # and current_time as the current time, return a boolean telling
  # me if this combination has expired or not.
  #
  def entry_expired?(epoch, ttl)
    if current_time - epoch > ttl
      return true
    else
      return false
    end
  end

  # Check if the entry exists in the data store
  def entry_exists?(key)
    cache_data.include?(key)    
  end

  # Load plugins
  def load_plugins
    plugins = Cache::Plugins.new
  end

end
