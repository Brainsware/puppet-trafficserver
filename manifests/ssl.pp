# setup of concat for ssl_multicert.config
class trafficserver::ssl {

  include 'concat::setup'
  include 'trafficserver::params'
  include 'trafficserver'

  $user  = $trafficserver::real_user
  $group = $trafficserver::real_group

  $configfile  = "${trafficserver::real_sysconfdir}/${trafficserver::params::ssl_config}"
  $conf_header = "${trafficserver::params::ssl_config_header}"

  # creates the configuration
  concat { $configfile:
    owner   => $user,
    group   => $group,
  }

  concat::fragment { "${configfile}_header":
    target => $configfile,
    source => $conf_header,
    order  => '00000',
  }
}
