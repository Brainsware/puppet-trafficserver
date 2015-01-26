# private class to handle basic records
class trafficserver::config::records {

  if $trafficserver::ssl and $trafficserver::listen == $trafficserver::params::listen {
    $port = $trafficserver::params::listen_ssl
  } else {
    $port = $trafficserver::listen
  }
  trafficserver_record { 'proxy.config.http.server_ports':
    value => $port,
  }

  trafficserver_record { 'proxy.config.admin.user_id':
    value => $trafficserver::user,
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
}
