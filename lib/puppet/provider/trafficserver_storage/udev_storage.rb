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

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'trafficserver_storage'))

Puppet::Type.type(:trafficserver_storage).provide(:udev_storage,
  :parent => ::Puppet::Provider::Trafficserver_storage,
) do

  desc 'Apache TrafficServer provider to allow access to raw storage devices in Linux'

  defaultfor  :kernel => :linux

  commands :udevadm => 'udevadm'

  Udev_file = '/etc/udev/rules.d/51-cache-disk.rules'

  # here we have to (idempotently) write an entry into
  # /etc/udev/rules.d/51-cache-disk.rules
  # why 51-cache-disk.rules? Because we've always done it like that.
  # What kind of entry? Well, for each raw disk supplied in storage.config
  # (that is, an entry that starts with /dev(ices)? and contains no size, we write
  #
  # SUBSYSTEM=="block", KERNEL=="/dev/that/device", GROUP:="provider.group"
  #
  # this hook is ran after storage.config has been updated. we'll disregard
  # the "filename" parameter, because we're not touching storage.config
  # instead we'll loop through @property_hash / @resources to find all raw
  # devices (those without a `size`) to build our "should" file-contents, and
  # compare it against the "is" we read from disk. if they don't match, we'll
  # overwrite "is" with "should".
  def self.post_flush_hook(filename)
    # restore group param
    @group       = @mapped_files[filename][:group]
    @udev_file   = Puppet::Util::FileType.filetype(:flat).new(Udev_file)
    @udev_is     = @udev_file.read
    @udev_should = Udev_header + generate_should
    unless @udev_is == @udev_should
      @udev_file.write(@udev_should)
      udevadm('trigger', '--subsystem-match=block')
    end
  end

  def self.generate_should
    instances.collect do |instance|
      if (instance.size.nil? or instance.size == :undef)
        "SUBSYSTEM==\"block\", KERNEL==\"#{instance.path}\", GROUP:=\"#{@group}\"" if instance.ensure == :present
      end
    end.join("\n")
  end

  Udev_header = <<-HEADER
#
# Do not attempt to modify this file. It's manged by puppet and will be
# overwritten on the next run!
#
# Assign cache disks to trafficserver's group
#
HEADER
end
