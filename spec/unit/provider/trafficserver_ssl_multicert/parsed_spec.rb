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

describe Puppet::Type.type(:trafficserver_ssl_multicert).provider(:parsed) do
  let(:name) { 'example.com.pem' }
  let(:resource_properties) do
    {
      ssl_cert_name: name,
      ssl_key_name: 'example.com.key',
      provider: described_class.name
    }
  end
  let(:resource) { Puppet::Type.type(:trafficserver_ssl_multicert).new(resource_properties) }
  let(:provider) { described_class.new(resource) }

  let(:prefetch_output) do
    <<-PREFETCH
# comment
ssl_cert_name=example.com.pem ssl_key_name=platform.coffee.key
PREFETCH
  end

  let(:instance) { provider.class.instances.first }

  describe 'self.prefetch' do
    it 'prefetch' do
      provider.class.instances
      provider.class.prefetch({})
    end
  end

  describe 'set values' do
    it 'sets an ssl_cert_name and key' do
      # unit testing providers is special, and rubocop doesn't understand :(
      provider.ssl_cert_name=(name) # rubocop:disable Style/SpaceAroundOperators, Style/RedundantParentheses
      provider.ssl_key_name=('example.com.key') # rubocop:disable Style/SpaceAroundOperators, Style/RedundantParentheses
    end
  end
end
