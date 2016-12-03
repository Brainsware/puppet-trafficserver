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

require 'spec_helper'

describe Puppet::Type.type(:trafficserver_record).provider(:traffic_line) do
  let(:record_name) { 'proxy.config.reverse_proxy.enabled' }
  let(:resource_properties) do
    {
      record: record_name,
      value: '1',
      provider: described_class.name
    }
  end
  let(:resource) { Puppet::Type.type(:trafficserver_record).new(resource_properties) }
  let(:provider) { described_class.new(resource) }

  # because of ``provider.class.instances.first``
  # we move our ``proxy.config.reverse_proxy.enabled 0`` to the top;)
  let(:prefetch_output) do
    <<-PREFETCH
proxy.config.reverse_proxy.enabled 0
proxy.config.ssl.enabled 0
proxy.config.ssl.SSLv2 0
proxy.config.ssl.SSLv3 0
proxy.config.ssl.TLSv1 1
proxy.config.ssl.TLSv1_1 1
proxy.config.ssl.TLSv1_2 1
proxy.config.ssl.compression 0
PREFETCH
  end

  before do
    Puppet::Util.stubs(:which).with('traffic_line').returns('/usr/bin/traffic_line')
    provider.class.stubs(:traffic_line).with('-m', 'proxy.(config|local|cluster).*').returns(prefetch_output)
    provider.class.stubs(:traffic_line).with(['-s', record_name, '-v', '1'])
  end

  let(:instance) { provider.class.instances.first }

  describe 'self.instances' do
    it 'returns an array of record => value pairs' do
      provider.class.stubs(:traffic_line).with(['-m', 'proxy.(config|local|cluster).*']).returns(prefetch_output)
    end
  end

  describe 'self.prefetch' do
    it 'prefetch' do
      provider.class.instances
      provider.class.prefetch({})
    end
  end

  describe 'value=' do
    it 'sets a traffic record' do
      # unit testing providers is special, and rubocop doesn't understand :(
      provider.record=(record_name) # rubocop:disable Style/SpaceAroundOperators, Style/RedundantParentheses
      provider.value=('1') # rubocop:disable Style/SpaceAroundOperators, Style/RedundantParentheses
    end
  end

  describe '#record' do
    it 'set #record to #name' do
      expect(instance.name).to eq(record_name)
    end
  end
end
