
class trafficserver::ssl {
  include 'trafficserver::params'

  validate_hash ( $trafficserver::ssl_hosts )
  unless has_key ($trafficserver::ssl_hosts, 'ssl_cert_name') {
    fail('\$trafficserver::ssl_hosts does not contain a key ssl_cert_name.')
  }

  file { "${trafficserver::sysconfdir}/ssl_multicert.config":
    content => template('trafficserver/ssl_multicert.config.erb'),
  }
}
