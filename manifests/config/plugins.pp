# This type handles adding values to plugins.config
define trafficserver::config::plugins (
  $changes
) {
  include 'trafficserver'

  $sysconfdir = $trafficserver::real_sysconfdir
  $configfile = "${sysconfdir}/plugins.config"

  $lens    = 'Trafficserver_plugins.lns'
  $context = "/files${configfile}"
  $incl    = $configfile

  augeas { "${lens}_${title}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes => $changes,
  }
}
