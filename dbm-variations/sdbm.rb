#!/usr/bin/env ruby

require 'sdbm'
require 'yaml'
require 'json'
require 'pp'

DB = "data/sdbm"

SDBM.new(DB)

testdata = {
  "/tmp/foo" => "asdf",
  "/tmp/foob" => "fdsa",
}

SDBM.open(DB) do |d|
  (1..30000).each do |n|
    # Different serializations for saving structured data
    d[n.to_s] = testdata.to_json
#    d[n.to_s] = testdata.to_yaml
#    d[n.to_s] = "somedata"
  end
end

d = SDBM.open(DB)
pp d.to_hash.sort
