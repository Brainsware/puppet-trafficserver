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

describe Puppet::Type.type(:trafficserver_plugin).provider(:parsed) do
  let(:name) { 'gzip.so' }
  let(:resource_properties) do
    {
      plugin: name,
      arguments: '/etc/trafficserver/gzip.conf'
    }
  end
  let(:resource) { Puppet::Type.type(:trafficserver_plugin).new(resource_properties) }
  let(:provider) { described_class.new(resource) }

  let(:prefetch_output) do
    <<-PREFETCH
# comment
stats_over_http.so
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
    it 'sets an plugin' do
      # unit testing providers is special, and rubocop doesn't understand :(
      provider.plugin=(name) # rubocop:disable Style/SpaceAroundOperators, Style/RedundantParentheses
    end
  end
end
