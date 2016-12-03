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

describe Puppet::Type.type(:trafficserver_ssl_multicert) do
  let(:resource) do
    Puppet::Type.type(:trafficserver_ssl_multicert).new(
      ssl_cert_name: 'example.com.pem',
      ssl_key_name:  'example.com.key',
      comment: 'our default test'
    )
  end

  it { expect(resource[:name]).to eq 'example.com.pem' }
  it { expect(resource[:ssl_cert_name]).to eq 'example.com.pem' }
  it { expect(resource[:ssl_key_name]).to eq 'example.com.key' }
  it { expect(resource[:comment]).to eq 'our default test' }
end
