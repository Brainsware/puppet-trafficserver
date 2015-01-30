#   Copyright 2014 Brainsware
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require 'puppet/provider/parsedfile'
require 'shellwords'

Puppet::Type.type(:trafficserver_ssl_multicert).provide(
  :parsed,
  :parent         => Puppet::Provider::ParsedFile,
  :default_target => '/etc/trafficserver/ssl_multicert.config',
  :filetype       => :flat,
) do

  text_line :comment, :match => /^\s*#/
  text_line :blank,   :match => /^\s*$/

  ValidKeys = [
    :ssl_cert_name,
    :dest_ip,
    :ssl_key_name,
    :ssl_key_dialog,
    :ssl_ca_name,
    :action,
  ]

  record_line :parsed,
    :fields   => %w{line_match}, # fake it. We'll parse with shellwords.split
    :match    => %r{
      ^[ \t]*                 # optional starting space, this is important of the repetition matcher below
       (.+?)                  # match the whole bloody line, and we'll take it apart later.
      [ \t]*$                 # optional: trailing spaces
    }x,
    :to_line => proc { |h|
      str  =  "ssl_cert_name=#{h[:ssl_cert_name]}"
      # following the style-guide in the ssl_multicert.config.default, we always set the dest_ip first
      str  =        "dest_ip=#{h[:dest_ip]} #{str}"      unless (h[:dest_ip].nil? or h[:dest_ip].empty? or h[:dest_ip] == :absent)
      str +=  " ssl_key_name=#{h[:ssl_key_name]}"        unless (h[:ssl_key_name].nil? or h[:ssl_key_name].empty? or h[:ssl_key_name] == :absent)
      str +=   " ssl_ca_name=#{h[:ssl_ca_name]}"         unless (h[:ssl_ca_name].nil? or h[:ssl_ca_name].empty? or h[:ssl_ca_name] == :absent)
      # quote ssl_key_dialog's value:
      str += " ssl_key_dialog=\"#{h[:ssl_key_dialog]}\"" unless (h[:ssl_key_dialog].nil? or h[:ssl_key_dialog].empty? or h[:ssl_key_dialog] == :absent)
      str += " action=#{h[:action]}"                     unless (h[:action].nil? or h[:action].empty? or h[:action] == :absent)
      str += " # #{h[:comment]}"                         unless (h[:comment].nil? or h[:comment].empty? or h[:comment] == :absent)

      # explicitly return full str:
      str
    },
    :post_parse => proc { |h|
      # use Shellwords#split to split the strings, since normal split won't do.
      # then, symbolize the key, and assign it the value
      Shellwords.split(h[:line_match]).each { |kv|
        key, value = kv.split('=')
        raise Puppet::ParseError, "Invalid key #{key}" unless ValidKeys.include?(key.to_sym)
        h[key.to_sym] = value.to_s
      }
      h[:name] = h[:ssl_cert_name]
    }
end
