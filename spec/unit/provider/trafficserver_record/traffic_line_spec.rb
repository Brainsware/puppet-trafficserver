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
  let(:name) { 'proxy.config.reverse_proxy.enabled' }
  let(:resource_properties) do
    {
      name: name,
      value: '1'
    }
  end
  let(:resource) { Puppet::Type::Trafficserver_record.new(resource_properties) }
  let(:provider) { described_class.new(resource) }
  let(:prefetch_output) do
    <<PREFETCH
proxy.config.ssl.enabled 0
proxy.config.ssl.SSLv2 0
proxy.config.ssl.SSLv3 0
proxy.config.ssl.TLSv1 1
proxy.config.ssl.TLSv1_1 1
proxy.config.ssl.TLSv1_2 1
proxy.config.ssl.compression 0
proxy.config.reverse_proxy.enabled 0
PREFETCH
  end

  before do
    Puppet::Util.stubs(:which).with('traffic_line').returns('/usr/bin/traffic_line')
    provider.class.stubs(:traffic_line).with('-m', 'proxy.(config|local|cluster).*').returns(prefetch_output)
    provider.class.stubs(:traffic_line).with('-s', name, '-v', '1')
  end

  let(:instance) { provider.class.instances.first }

  describe 'self.prefetch' do
    it 'exists' do
      provider.class.instances
      provider.class.prefetch({})
    end
  end

  describe 'value=' do
    it 'sets a traffic record' do
      provider.expects(:traffic_line).with('-s', name, '-v', '1')
      provider.expects(:exists?).returns true
      expect(provider.value).to be '1'
    end
  end

  context 'default example' do
    describe '#record' do
      it 'set #record to #name' do
        expect(provider.record).to be name
      end
    end

    describe '#value' do
      it 'set #value to 1' do
        expect(provider.value).to be '1'
      end
    end
  end
end
