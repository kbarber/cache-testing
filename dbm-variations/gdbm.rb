#!/usr/bin/env ruby

require 'gdbm'
require 'pp'

DB = "data/gdbm"

GDBM.new(DB)

GDBM.open(DB) do |d|
  d["foo"] = "someshit from thread"
end

d = GDBM.open(DB)
pp d.to_hash
