#!/usr/bin/env ruby

require 'rubygems'
require 'sqlite3'

SQLite3::Database.new("data/loadtest.db") do |db|
  db.transaction
  db.execute("create table if not exists facter (k STRING PRIMARY KEY ASC, v STRING)")
  db.commit
end

(1..100).each do |c|
  SQLite3::Database.new("data/basic.db") do |db|
    db.transaction
    db.execute("replace into facter values ('key#{c}', 'value')")
    db.commit
  end
end
