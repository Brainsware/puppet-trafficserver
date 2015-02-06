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
    :block_eval => instance do
      def emptyish?(x)
        x.nil? or x.empty? or x == :absent
      end

      def to_line(h)
        str  = h[:plugin]
        str += " #{h[:arguments].join(' ')}" unless emptyish?(h[:arguments])
        str += " # #{h[:comment]}"           unless emptyish?(h[:comment])

        # explicitly return full str
        str
      end

      # if there's a comment sign, we can split on that
      def post_parse(h)
        conf, comment = h[:line_match].split('#', 2) # catch comments in comments ;)
        h[:plugin], *h[:arguments] = conf.split
        h[:comment]                = comment.strip unless (emptyish?(comment))

        h[:ensure] = :present
        h[:name]   = h[:plugin]
      end
    end
end
