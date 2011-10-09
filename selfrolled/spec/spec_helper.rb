$LOAD_PATH.unshift("../../lib")

require 'tempfile'

def tmpfile
  Tempfile.new("cache")
end
