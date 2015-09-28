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

Puppet::Type.type(:trafficserver_record).provide(:traffic_line) do

  desc 'Manage traffic server records.config entries using traffic_line command'

  commands :traffic_line => 'traffic_line'

  mk_resource_methods

  ConfigPattern = 'proxy.(config|local|cluster).*'

  # this method is only called when value isn't insync?
  def value=(value)
    @property_hash[:value] = value

    options = []
    options << '-s' << @property_hash[:record]
    options << '-v' << value
    traffic_line(options)
  end

  # get all records.config entries at the beginning
  def self.instances
    records = traffic_line('-m', ConfigPattern)
    records.split("\n").collect do |line|
      name, value = line.split(' ', 2)
      # and initialize @property_hash
      new( :name   => name,
           :record => name,
           :value  => value.to_s)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

end
