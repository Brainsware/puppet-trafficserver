#   Copyright 2013 Brainsware
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

# This class manages pretty much all of traffic server's configuration
# But does so via calling upon other classes/defined types to help it.
class trafficserver::config inherits trafficserver {

  anchor { '::trafficserver::config::start': }

  class { '::trafficserver::storage': }

  $port_changes = [ "set proxy.config.http.server_ports \"${port}\"" ]
  trafficserver::config::records { 'port':
    changes => $port_changes,
  }

  $debug_changes = [
      "set proxy.config.http.insert_request_via_str ${debug}",
      "set proxy.config.http.insert_response_via_str ${debug}",
    ]
  trafficserver::config::records { 'debug':
    changes => $debug_changes ,
  }

  $mode_changes = $mode ? {
    'reverse' => $::trafficserver::params::mode_reverse,
    'forward' => $::trafficserver::params::mode_forward,
    'both'    => $::trafficserver::params::mode_both,
    # Default is reverse
    default => $::trafficserver::params::mode_reverse
  }

  trafficserver::config::records { 'mode':
    changes => $mode_changes,
  }

  $records = $trafficserver::records
  if $records {
    trafficserver::config::records { 'global_records':
      changes => $records,
    }
  }

  if $ssl {
    include trafficserver::ssl
    if $ssl_default {
      trafficserver::config::ssl { 'default':
        ssl_host => $ssl_default,
      }
    }
  }

  # And finally, create an exec here to reload
  exec { 'trafficserver-config-reload':
    path        => $bindir,
    command     => 'traffic_line -x',
    cwd         => '/',
    refreshonly => true,
  }
  
  anchor { '::trafficserver::config::end': }

  Anchor['::trafficserver::config::start'] ->
  Class['::trafficserver::storage'] ->
  Anchor['::trafficserver::config::end']

}
