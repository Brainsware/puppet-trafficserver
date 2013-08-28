# This type handles adding values to records.config
define trafficserver::config::records (
  $changes
) {
  include 'trafficserver'

  $sysconfdir = $trafficserver::real_sysconfdir
  $configfile = "${sysconfdir}/records.config"

  $lens    = 'Trafficserver_records.lns'
  $context = "/files${configfile}"
  $incl    = $configfile

  augeas { "${lens}_${title}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes => $changes,
  }
}
