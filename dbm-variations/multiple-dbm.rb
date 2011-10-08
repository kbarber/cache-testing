#!/usr/bin/env ruby

require 'dbm'
require 'pp'

DB = "data/multiple-dbm"

DBM.new(DB)

(1..100).each do |c|
  DBM.open(DB) do |d|
    d["data#{c}"] = "thread"
  end
end
