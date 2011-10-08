#!/usr/bin/env ruby

require 'yaml'
require 'thread'
require 'pp'

class Cache
  def initialize(file)
    @cache_file = file
    @data = {}
    @semaphore = Mutex.new
  end

  def []=(key, value, ttl = nil)
    @semaphore.synchronize do
      @data[key] = {
        :data => value,
        :stored => Time.now.to_i,
        :ttl => ttl
      }
    end
  end

  def [](key)
    @data[key][:data]
  end

  def to_hash
    @data
  end
end

a = Cache.new("data/dirty.yaml")
a["a"] = "a"
pp a
