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

Puppet::Type.newtype(:trafficserver_storage) do

  ensurable

  newparam(:path, :namevar => true) do
    desc "path to directory or device"
  end

  # this is taken from postgresql_conf
  newproperty(:target) do
    desc "The path to plugin.config"
    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    end
  end

  newproperty(:size) do
    desc "size: only used for directories"
  end

  newproperty(:comment) do
    desc "optional comment"
  end
end
