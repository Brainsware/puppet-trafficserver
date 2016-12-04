#   Copyright 2016 Brainsware
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

Puppet::Type.type(:trafficserver_record).provide(:traffic_ctl) do
  desc 'Manage traffic server records.config entries using traffic_ctl command'

  commands traffic_ctl: 'traffic_ctl'

  mk_resource_methods

  # this method is only called when value isn't insync?
  def value=(value)
    @property_hash[:value] = value

    options = ['config']
    options << 'set' << @property_hash[:record] << value
    traffic_ctl(options)
  end

  # get all records.config entries at the beginning
  def self.instances
    records = traffic_ctl('config', 'match', '.')
    records.split("\n").map do |line|
      name, value = line.split(%r{:\s+}, 2)
      # and initialize @property_hash
      new(name: name,
          record: name,
          value: value.to_s)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name] # rubocop:disable Lint/AssignmentInCondition
        resource.provider = prov
      end
    end
  end
end
