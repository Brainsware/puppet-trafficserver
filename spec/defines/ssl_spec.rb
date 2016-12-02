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

describe 'trafficserver::config::ssl', type: :define do
  let :facts do
    {
      concat_basedir: '/dne'
    }
  end

  context 'README test: single' do
    let(:title) { 'README example: single' }
    mail = {
      'ssl_cert_name' => '/etc/ssl/certs/mail.example.com.crt',
      'ssl_key_name'  => '/etc/ssl/keys/mail.example.com.key'
    }
    let(:params) do
      {
        'ssl_host' => mail
      }
    end

    it do
      is_expected.to contain_concat__fragment('/etc/trafficserver/ssl_multicert.config_README example: single'). \
        with_content(%r{ssl_cert_name=.+mail.+crt ssl_key_name=.+mail.+key \n})
    end
  end
  context 'README test: multiple' do
    let(:title) { 'README example: multiple' }
    example_com = [{
      'ssl_cert_name' => '/etc/ssl/certs/mail.example.com.crt',
      'ssl_key_name'  => '/etc/ssl/keys/mail.example.com.key'
    }, {
      'ssl_cert_name' => '/etc/ssl/certs/www.example.com.crt',
      'ssl_key_name'  => '/etc/ssl/keys/www.example.com.key'
    }]
    let(:params) do
      {
        'ssl_hosts' => example_com
      }
    end

    it do
      is_expected.to contain_concat__fragment('/etc/trafficserver/ssl_multicert.config_README example: multiple'). \
        with_content(%r{ssl_cert_name=.+mail.+crt ssl_key_name=.+mail.+key \n}).
        with_content(%r{ssl_cert_name=.+www.+crt ssl_key_name=.+www.+key \n})
    end
  end
end
