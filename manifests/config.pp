# This class manages pretty much all of traffic server's configuration
# But does so via calling upon other classes/defined types to help it.
class trafficserver::config {

  include 'trafficserver'
  include 'trafficserver::storage'

  $sysconfdir = $trafficserver::sysconfdir
  $bindir     = $trafficserver::bindir

  $port = $trafficserver::real_port
  $port_changes = [ "set proxy.config.http.server_ports \"${port}\"" ]
  trafficserver::config::records { 'port':
    changes => $port_changes,
  }

  $debug = $trafficserver::real_debug
  $debug_changes = [
      "set proxy.config.http.insert_request_via_str ${debug}",
      "set proxy.config.http.insert_response_via_str ${debug}"
    ]
  trafficserver::config::records { 'debug':
    changes => $debug_changes ,
  }

  $mode = $trafficserver::real_mode
  validate_re ($mode, $valid_modes)

  $mode_changes = $mode ? {
    'reverse' => $trafficserver::params::mode_reverse,
    'forward' => $trafficserver::params::mode_forward,
    'both' => $trafficserver::params::mode_both,
    # Default is reverse
    default => $trafficserver::params::mode_reverse
  }

  trafficserver::config::records { 'mode':
    changes => $mode_changes,
  }

  $records = $trafficserver::real_records
  if $records {
    trafficserver::config::records { 'global_records':
      changes => $records,
    }
  }

  $ssl = $trafficserver::real_ssl
  $ssl_default = $trafficserver::real_ssl_default
  if $ssl {
    include trafficserver::ssl
    unless $ssl_default == {} {
      trafficserver::config::ssl { 'default':
        ssl_host => $ssl_default,
      }
    }
  }

}
