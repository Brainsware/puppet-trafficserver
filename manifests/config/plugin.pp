# This type handles adding values to plugins.config
define trafficserver::config::plugin (
  $plugin = $title,
  $args = [],
) {
  include trafficserver
  include trafficserver::params

  $sysconfdir = $trafficserver::real_sysconfdir
  $configfile = "${sysconfdir}/plugins.config"

  $plugin_extension = $trafficserver::params::plugin_extension

  $lens    = 'Trafficserver_plugins.lns'
  $context = "/files${configfile}"
  $incl    = $configfile

  augeas { "${lens}_${title}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes => template('trafficserver/plugin.config.erb'),
    notify  => Exec[trafficserver-config-reload],
  }
}
