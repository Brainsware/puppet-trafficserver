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
  include 'concat::setup'
  include 'trafficserver::params'
  include 'trafficserver'

  $sysconfdir = $trafficserver::real_sysconfdir
  $configfile = "${sysconfdir}/${trafficserver::params::ssl_config}"
  $template   = $trafficserver::params::ssl_config_template
  $comment    = $title

  validate_hash ( $ssl_host )
  unless has_key ($ssl_host, 'ssl_cert_name') {
    fail('\$ssl_hosts does not contain a key ssl_cert_name.')
  }

  concat::fragment { "${sysconfdir}/ssl_multicert.config_${comment}":
    target  => $configfile,
    content => template($template),
    order   => '99999',
    notify  => Exec[trafficserver-config-reload],
  }
}
