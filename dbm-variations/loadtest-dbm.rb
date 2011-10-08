#!/usr/bin/env ruby

require 'dbm'
require 'pp'

DB = "data/loadtest-dbm"

DBM.new(DB)

(1..100).each do |thr|
  Thread.new do
#    sleep(rand*5)
    (1..100).each do |change|
      DBM.open(DB) do |d|
        d[change] = "someshit from thread #{thr}"
      end
    end
  end
end

DBM.open(DB) do |d|
  pp d.to_hash
end
