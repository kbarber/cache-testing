#!/usr/bin/env ruby

require 'dbm'
require 'pp'

DB = "data/dbm"

DBM.new(DB)

DBM.open(DB) do |d|
  d["foo"] = "someshit from thread"
end

d = DBM.open(DB)
pp d.to_hash
