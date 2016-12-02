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

describe 'trafficserver::config::remap', type: :define do
  context 'README tests' do
    map = {
      'http://example.com' => 'http://backend-web01',
      'http://example.org' => 'http://backend-web21',
      'http://example.net' => 'http://backend-web42'
    }
    rev_map = {
      'http://backend-web01' => 'http://example.com',
      'http://backend-web21' => 'http://example.org',
      'http://backend-web42' => 'http://example.net'
    }
    redirect = {
      'http://example.co.uk' => 'http://example.com/uk'
    }
    let(:title) { 'README examples' }
    let(:params) do
      {
        'map'      => map,
        'rev_map'  => rev_map,
        'redirect' => redirect
      }
    end

    it { is_expected.to contain_augeas('Trafficserver_remap.lns_README examples') }
  end
end
