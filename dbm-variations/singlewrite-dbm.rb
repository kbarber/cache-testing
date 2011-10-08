#!/usr/bin/env ruby

require 'dbm'
require 'pp'

DB = "data/singlewrite-dbm"

DBM.new(DB)

DBM.open(DB) do |d|
  d["data"] = "thread1"
end
