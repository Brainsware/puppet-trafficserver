# "private" defined type for platform specifics
define trafficserver::storage::Linux (
  $ensure = 'present',
  $device = $title,
  $group  = $trafficserver::group,
  $owner  = $trafficserver::group,
) {
  concat::fragment {
    ensure  => $ensure,
    content => template($trafficserver::params::device_template),
  } ~>
  exec { 'update udev rules':
    command     => 'udevadm trigger --subsystem-match=block',
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    cwd         => '/',
    refreshonly => true,
  }
}
