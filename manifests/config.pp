#   Copyright 2015 Brainsware
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

# This class manages some basics of traffic server's configuration
# For more complex things settings, please use trafficserver_record directly!
# or any other (defined) types.
class trafficserver::config {

  # basic (concat) setup for trafficserver storage
  include trafficserver::config::storage

  if $trafficserver::ssl and $trafficserver::listen == $trafficserver::params::listen {
    $port = $trafficserver::params::listen_ssl
  } else {
    $port = $trafficserver::listen
  }
  trafficserver_record { 'proxy.config.http.server_ports':
    value => $port,
  }

  trafficserver_record {
    'proxy.config.http.insert_request_via_str':
      value => $trafficserver::debug;
    'proxy.config.http.insert_response_via_str':
      value =>  $trafficserver::debug;
  }

  case $trafficserver::mode {
    'forward': {
      $remap_required         = '0'
      $reverse_proxy_enabled  = '0'
    }
    'both': {
      $remap_required         = '0'
      $reverse_proxy_enabled  = '1'
    }
    # Default is reverse
    default: {
      $remap_required         = '1'
      $reverse_proxy_enabled  = '1'
    }
  }
  trafficserver_record {
    'proxy.config.url_remap.remap_required':
      value => $remap_required;
    'proxy.config.reverse_proxy.enabled':
      value => $reverse_proxy_enabled;
  }

  # And finally, create an exec here to reload
  exec { 'trafficserver-config-reload':
    path        => $trafficserver::bindir,
    command     => 'traffic_line -x',
    cwd         => '/',
    refreshonly => true,
  }

  anchor { '::trafficserver::config::end': }

  Anchor['::trafficserver::config::start'] ->
  Class['::trafficserver::storage'] ->
  Anchor['::trafficserver::config::end']

}
