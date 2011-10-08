#!/usr/bin/env ruby

require 'sdbm'
require 'pp'

DB = "data/tsdata"

SDBM.new(DB)

thread1 = Thread.new do 
  SDBM.open(DB) do |d|
    sleep 10
    d["data"] = "thread1"
    puts "thread1"
  end
end

thread2 = Thread.new do
  sleep 5
  SDBM.open(DB) do |d|
    d["data"] = "thread2"
    puts "thread2"
  end
end

thread1.join
thread2.join

d = SDBM.open(DB)
pp d.to_hash.sort
