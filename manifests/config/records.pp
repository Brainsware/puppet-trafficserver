# This type handles adding values to records.config
define trafficserver::config::records (
  $changes
) {
  include 'trafficserver'
  $lens    = 'Trafficserver_records.records_lns'
  $context = "/files${trafficserver::sysconfdir}/records.config"
  $incl    = "${trafficserver::sysconfdir}/records.config"

  augeas { "${lens}_${title}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes => $changes,
  }
}
