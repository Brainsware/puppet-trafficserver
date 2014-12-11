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

Puppet::Type.newtype(:trafficserver_storage_dir) do

  require 'pry' ; binding.pry

  ensurable

  newparam(:path, :namevar => true) do
    desc "fully qualified path to directory"
  end

  newproperty(:size) do
    desc "size: only used for directories"
    newvalues(/^\d+[KMGTP]?$/)
  end

  newproperty(:comment) do
    desc "optional comment"
  end

  # it's hard to discover these from the system, so we won't attempt to.
  # They have to be passed.

  newparam(:owner) do
    desc "owner of device or directory"
    defaultto 'trafficserver'
  end

  newparam(:group) do
    desc "group of device or directory"
    defaultto 'trafficserver'
  end

  def generate
    require 'pry' ; binding.pry
    []
  end
end
