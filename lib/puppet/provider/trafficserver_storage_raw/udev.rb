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

Puppet::Type.type(:trafficserver_storage_dev).provide(:udev_storage) do

  require 'pry'; binding.pry

  desc 'Apache TrafficServer provider to allow access to raw storage devices in Linux'

  defaultfor  :kernel => :linux

  commands :udevadm => 'udevadm'

  Udev_file      = '/etc/udev/rules.d/51-cache-disk.rules'
  Parent_target  = ::Puppet::Provider::Trafficserver_storage::Default_target

  def self.instances
    s = super
    @group       = @mapped_files[Parent_target][:group]
    @udev_file   = Puppet::Util::FileType.filetype(:flat).new(Udev_file)
    require 'pry' ; binding.pry
    return s
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
