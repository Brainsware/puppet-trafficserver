#
# hash_invert.rb
#

module Puppet::Parser::Functions
  newfunction(:hash_invert, :type => :rvalue, :doc => <<-EOS
Returns a hash with this hash's keys as values, and values as keys.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "hash_invert(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    hash = arguments[0]

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'hash_invert(): Requires hash to work with')
    end

    result = hash.invert

    return result
  end
end

# vim: set ts=2 sw=2 et :
