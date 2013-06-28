# This type handles adding values to plugins.config
define trafficserver::config::plugins (
  $changes
) {
  include 'trafficserver'

  $sysconfdir = $trafficserver::real_sysconfdir

  $lens    = 'Trafficserver_plugins.plugins_lns'
  $context = "/files${sysconfdir}/plugins.config"
  $incl    = "${sysconfdir}/plugins.config"

  augeas { "${lens}_${title}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes => $changes,
  }
}
