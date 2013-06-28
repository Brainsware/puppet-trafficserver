# This type handles adding values to records.config
define trafficserver::config::records (
  $changes
) {
  include 'trafficserver'

  $sysconfdir = $trafficserver::real_sysconfdir

  $lens    = 'Trafficserver_records.records_lns'
  $context = "/files${sysconfdir}/records.config"
  $incl    = "${sysconfdir}/records.config"

  augeas { "${lens}_${title}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes => $changes,
  }
}
