#!/usr/bin/env ruby

require 'sdbm'
require 'pp'

DB = "data/singlewrite-sdbm"

SDBM.new(DB)

SDBM.open(DB) do |d|
  d["data"] = "thread1"
end
