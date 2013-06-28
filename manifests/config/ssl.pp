# This type handles adding ssl "vhosts" to ssl_multicert.config
#     ssl_host          => {
#       'dest_ip'       => '*',
#       'ssl_cert_name' => 'bar.pem',
#       'ssl_key_name'  => 'barKey.pem',
#       'ssl_ca_name'   => 'Ca.pem'
#     },
define trafficserver::config::ssl (
  $ssl_host,
){
  include 'trafficserver'
  include 'trafficserver::params'

  $sysconfdir = $trafficserver::sysconfdir
  $configfile = "sysconfdir/${trafficserver::params::ssl_config}"
  $comment    = $title

  validate_hash ( $ssl_host )
  unless has_key ($ssl_host, 'ssl_cert_name') {
    fail('\$ssl_hosts does not contain a key ssl_cert_name.')
  }

  file { "${sysconfdir}/ssl_multicert.config_${comment}":
    target  => $configfile,
    content => template('trafficserver/ssl_multicert.config.erb'),
  }
}
