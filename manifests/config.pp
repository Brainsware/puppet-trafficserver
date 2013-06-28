# This class manages pretty much all of traffic server's configuration
# But does so via calling upon other classes/defined types to help it.
class trafficserver::config {

  include 'trafficserver'
  include 'trafficserver::storage'

  $port = $trafficserver::port
  $port_changes = [ "set proxy.config.http.server_ports \"${port}\"" ]
  trafficserver::config::records { 'port':
    changes => $port_changes,
  }

  $debug = $trafficserver::debug
  $debug_changes = [
      "set proxy.config.http.insert_request_via_str ${debug}",
      "set proxy.config.http.insert_response_via_str ${debug}"
    ]
  trafficserver::config::records { 'debug':
    changes => $debug_changes ,
  }

  $mode = $trafficserver::mode
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

  $records = $trafficserver::records
  unless $records == [] {
    trafficserver::config::records { 'records':
      changes => $records,
    }
  }

  augeas { 'trafficserver.plugins':
    lens    => 'Trafficserver_plugin.plugin_lns',
    context => "/files${trafficserver::sysconfdir}/plugin.config",
    incl    => "${trafficserver::sysconfdir}/plugin.config",
    changes =>  template('trafficserver/plugin.config.erb'),
  }

  $ssl = $trafficserver::ssl
  $ssl_default = $trafficserver::ssl_default
  if $ssl {
    unless $ssl_default == {} {
      trafficserver::config::ssl { 'default':
        ssl_host => $ssl_default,
      }
    }
  }

}
