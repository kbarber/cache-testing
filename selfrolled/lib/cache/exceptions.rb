require 'cache'

class Cache
  # Parent exception class for Cache
  class Exception < Exception
  end

  # Exceptions related to method parameters
  class ParameterException < Exception
  end

  # Raised when an entry has expired in the cache
  # this is needed, as you can't use returned data
  # as a reliable indication of expiration since almost
  # all values are valid (including nil).
  class EntryExpired < Exception
  end

  # Raised when an entry has missing entry in the cache
  # this is needed, as you can't use returned data
  # as a reliable indication of missing data since almost
  # all values are valid (including nil).
  class EntryMissing < Exception
  end

end
