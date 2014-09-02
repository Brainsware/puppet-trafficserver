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

require 'puppetx/filemapper'

Puppet::Type.type(:trafficserver_storage).provide(:storage) do

  desc 'Apache TrafficServer provider for parsing and writing storage.config'

  include PuppetX::FileMapper

  commands :mkdir  => 'mkdir',
           :chown  => 'chown'

  @default_target = '/etc/trafficserver/storage.config'
  @blank      = /^\s*$/
  @comment    = /^\s*#/
  @line_match =  %r{
      ^[ \t]*  # optional starting space, this is important of the repetition matcher below
      (.+?)    # match the whole bloody line, and we'll take it apart later.
      [ \t]*$  # optional: trailing spaces
    }x


  def select_file
    @default_target
  end

  def self.target_files
    [ @default_target ]
  end

  def self.parse_file(filename, file_contents)
    lines = file_contents.split("\n")

    real_lines = lines.delete_if { |l| l =~ @blank || l =~ @comment }

    real_lines.collect { |line| line.match(@line_match) }.compact.collect do |m|

      line_match    = m[1]
      conf, comment = line_match.split('#', 2) # catch comments in comments ;)
      path, *size   = conf.split
      comment       = comment.strip unless comment.nil?

      # validate, that which cannot be sensibly validated in the type:
      raise Puppet::ParseError, "Invalid format: <path> [<size>]" if size.size > 1

      # init @property_hash, by returning a hash
      {
        :name     => path,
        :path     => path,
        :size     => size.first,
        :comment  => comment,
      }
    end
  end

  def self.format_file(filename, providers)
    providers.collect do |provider|

      # if it's a directory, create and chown them.
      if provider.size && !Dir.exist?(provider.path)
        mkdir('-p', provider.path)
        chown("#{provider.owner}:#{provider.group}", provider.path)
      end

      line  = "#{provider.path}"
      line += " #{provider.size}"      unless (provider.size.nil?    || provider.size    == :undef)
      line += " # #{provider.comment}" unless (provider.comment.nil? || provider.comment == :undef)

    end.join
  end

  require 'pry' ; binding.pry

end
