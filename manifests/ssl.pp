
class trafficserver::ssl {
  include 'trafficserver'
  include 'trafficserver::params'

  validate_array ( $trafficserver::ssl_hosts )
  # validate_hash ( $trafficserver::ssl_hosts, [0, -1])
  # Okay, this doesn't go deep enough
  #  unless has_key ($trafficserver::ssl_hosts, 'ssl_cert_name') {
  #    fail('\$trafficserver::ssl_hosts does not contain a key ssl_cert_name.')
  #  }

  file { "${trafficserver::sysconfdir}/ssl_multicert.config":
    content => template('trafficserver/ssl_multicert.config.erb'),
  }
}
