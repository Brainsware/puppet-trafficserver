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

Puppet::Type.type(:trafficserver_record).provide(:traffic_line) do

  desc 'Manage traffic server records.config entries using traffic_line command'

  commands :traffic_line => 'traffic_line'

  mk_resource_methods

  ConfigPattern = 'proxy.(config|local|cluster).*'

  def initialize(value={})
    super(value)
  end

  def name=(value)
    @property_hash[:name] = value
  end

  def value=(value)
    @property_hash[:name]  = resource[:name]
    @property_hash[:value] = value
    # if the value is equal, we're done here (or else we're not idempotent!)
    return if value == resource[:value]

    options = []
    options << '-s' << @property_hash[:name]
    options << '-v' << @property_hash[:value]
    traffic_line(options)
  end

  # get all records.config entries at the beginning
  def self.instances
    records = traffic_line('-m', ConfigPattern)
    records.split("\n").collect do |line|
      name, value = line.split(' ', 2)
      # and initialize @property_hash
      new( :name  => name,
           :value => value.to_s)
    end
  end

  def self.prefetch(resources)
    records = instances
    resources.keys.each do |record|
      if provider = records.find{ |rec| rec.name == name }
        resources[name].provider = provider
      end
    end
  end

end
