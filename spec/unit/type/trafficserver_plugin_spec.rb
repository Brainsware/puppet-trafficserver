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

describe Puppet::Type.type(:trafficserver_plugin) do
  let(:resource) do
    Puppet::Type.type(:trafficserver_plugin).new(
      plugin: 'gzip.so',
      comment: 'enable gzip on the edge',
      arguments: '/etc/trafficserver/gzip.conf'
    )
  end

  it { expect(resource[:name]).to eq 'gzip.so' }
  it { expect(resource[:plugin]).to eq 'gzip.so' }
  it { expect(resource[:comment]).to eq 'enable gzip on the edge' }
  it { expect(resource[:arguments]).to eq ['/etc/trafficserver/gzip.conf'] }

  context 'no arguments, no comments' do
    let(:resource) do
      Puppet::Type.type(:trafficserver_plugin).new(
        plugin: 'stats_over_http.so'
      )
    end

    it { expect(resource[:name]).to eq 'stats_over_http.so' }
    it { expect(resource[:plugin]).to eq 'stats_over_http.so' }
  end
end
