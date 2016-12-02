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

describe 'trafficserver::remap', type: :define do
  let(:facts) do
    on_supported_os.first
  end
  let(:pre_condition) { 'include ::trafficserver' }

  {
    example_com: { from: 'http://example.com', to: 'http://backend-web01' },
    example_org: { from: 'http://example.org', to: 'http://backend-web21' },
    example_net: { from: 'http://example.net', to: 'http://backend-web42' },
    # reverse maps
    rev_example_com: { type: 'reverse_map', from: 'http://backend-web01', to: 'http://example.com' },
    rev_example_org: { type: 'reverse_map', from: 'http://backend-web21', to: 'http://example.org' },
    rev_example_net: { type: 'reverse_map', from: 'http://backend-web42', to: 'http://example.net' },
    # redirects
    redirect_co_uk: { type: 'redirect', from: 'http://example.co.uk', to: 'http://example.com/uk' }
  }.map do |remap, maps|
    context "README examples: #{remap}" do
      let(:title) { "#{maps[:type]} from #{maps[:from]} to #{maps[:to]}" }
      let(:params) do
        {
          type: maps[:type],
          from: maps[:from],
          to:   maps[:to]
        }
      end
      it { is_expected.to compile }
    end
  end
end
