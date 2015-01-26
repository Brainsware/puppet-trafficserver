#   Copyright 2015 Brainsware
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

Puppet::Type.type(:trafficserver_plugin).provide(
  :parsed,
  :parent         => Puppet::Provider::ParsedFile,
  :default_target => '/etc/trafficserver/plugin.config',
  :filetype       => :flat,
) do

  text_line :comment, :match => /^\s*#/
  text_line :blank,   :match => /^\s*$/

  record_line :parsed,
    :fields   => %w{line_match}, # no need for regex here
    :match    => %r{
      ^[ \t]*                 # optional: starting space
       (.+?)                  # match the whole line, we'll take it apart in post_parse.
      [ \t]*$                 # optional: trailing spaces
    }x,
    :to_line => proc { |h|
      str  = h[:plugin]
      str += h[:arguments].join(' ') unless (h[:arguments].nil? or h[:arguments].empty? or h[:arguments] == :absent)
      str += " # #{h[:comment]}"     unless (h[:comment].nil?   or h[:comment].empty?   or h[:comment]   == :absent)
    },
    # if there's a comment sign, we can split on that
    :post_parse => proc { |h|
      conf, comment = h[:line_match].split('#', 2) # catch comments in comments ;)
      h[:plugin], *h[:arguments] = conf.split
      h[:comment]                = comment.strip unless (comment.nil? or comment.empty? or comment == :absent)

      h[:ensure] = :present
      h[:name]   = h[:plugin]
    }
end
