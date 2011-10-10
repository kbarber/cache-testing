$LOAD_PATH.unshift("../../lib")

require 'tempfile'
require 'mocha'

def tmpfile
  Tempfile.new("cache")
end
