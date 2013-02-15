class trafficserver::config {
  include 'trafficserver::params'
  include 'trafficserver::storage'

  augeas { 'trafficserver.records_port':
    context => "/files/${trafficserver::sysconfdir}/records.config",
    changes => [
      "set proxy.config.http.server_ports ${trafficserver::port}"
    ],
  }

  augeas { 'trafficserver.records_debug':
    context => "/files/${trafficserver::sysconfdir}/records.config",
    changes => [
      "set proxy.config.http.insert_request_via_str ${trafficserver::debug}",
      "set proxy.config.http.insert_response_via_str ${trafficserver::debug}"
    ],
  }

  $changes_mode = $trafficserver::mode ? {
    'reverse' => [
      'set proxy.config.url_remap.remap_required 1',
      'set proxy.config.reverse_proxy.enabled 1',
    ],
    'forward' => [
      'set proxy.config.url_remap.remap_required 0',
      'set proxy.config.reverse_proxy.enabled 0',
    ],
    'both' => [
      'set proxy.config.url_remap.remap_required 0',
      'set proxy.config.reverse_proxy.enabled 1',
    ],
    # Default is reverse
    default => [
      'set proxy.config.url_remap.remap_required 1',
      'set proxy.config.reverse_proxy.enabled 1',
    ],
  }

  augeas { 'trafficserver.records_mode':
    context => "/files/${trafficserver::sysconfdir}/records.config",
    changes => $changes_mode,
  }

  augeas { 'trafficserver.records_records':
    context => "/files/${trafficserver::sysconfdir}/records.config",
    changes => $trafficserver::records,
  }

  augeas { 'trafficserver.remap':
    context => "/files/${trafficserver::sysconfdir}/remap.config",
    changes =>  template('trafficserver/remap.config.erb'),
  }

  augeas { 'trafficserver.plugins':
    context => "/files/${trafficserver::sysconfdir}/plugin.config",
    changes =>  template('trafficserver/plugin.config.erb'),
  }
}
