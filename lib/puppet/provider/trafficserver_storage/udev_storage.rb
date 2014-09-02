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

Puppet::Type.type(:trafficserver_storage).provide(:udev_storage,
  :parent => :storage,
) do

  desc 'Apache TrafficServer provider for allow access to raw storage devices in Linux'

  confine  :kernel => :linux

  # here we have to (idempotently) write an entry into
  # /etc/udev/rules.d/51-cache-disk.rules
  # why 51-cache-disk.rules? Because we've always done it like that.
  # What kind of entry? Well, for each raw disk supplied in storage.config
  # (that is, an entry that starts with /dev(ices)? and contains no size, we write
  #
  # SUBSYSTEM=="block", KERNEL=="/dev/that/device", GROUP:="provider.group"

end
