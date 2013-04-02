class trafficserver::config {

  include 'trafficserver::params'
  include 'trafficserver::storage'
  include 'trafficserver::config'

  augeas { 'trafficserver.records_port':
    lens    => 'Trafficserver_records.records_lns',
    context => "/files${trafficserver::sysconfdir}/records.config",
    incl    => "${trafficserver::sysconfdir}/records.config",
    changes => [
      "set proxy.config.http.server_ports ${trafficserver::port}"
    ],
  }

  augeas { 'trafficserver.records_debug':
    lens    => 'Trafficserver_records.records_lns',
    context => "/files${trafficserver::sysconfdir}/records.config",
    incl    => "${trafficserver::sysconfdir}/records.config",
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
    lens    => 'Trafficserver_records.records_lns',
    context => "/files${trafficserver::sysconfdir}/records.config",
    incl    => "${trafficserver::sysconfdir}/records.config",
    changes => $changes_mode,
  }

  augeas { 'trafficserver.records_records':
    lens    => 'Trafficserver_records.records_lns',
    context => "/files${trafficserver::sysconfdir}/records.config",
    incl    => "${trafficserver::sysconfdir}/records.config",
    changes => $trafficserver::records,
  }

  augeas { 'trafficserver.remap':
    lens    => 'Trafficserver_remap.remap_lns',
    context => "/files${trafficserver::sysconfdir}/remap.config",
    incl    => "${trafficserver::sysconfdir}/remap.config",
    changes =>  template('trafficserver/remap.config.erb'),
  }

  augeas { 'trafficserver.plugins':
    lens    => 'Trafficserver_plugin.plugin_lns',
    context => "/files${trafficserver::sysconfdir}/plugin.config",
    incl    => "${trafficserver::sysconfdir}/plugin.config",
    changes =>  template('trafficserver/plugin.config.erb'),
  }
}
