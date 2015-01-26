# "private" defined type for platform specifics
define trafficserver::storage::linux (
  $ensure = 'present',
  $path   = $title,
  $size   = undef,
  $group  = $trafficserver::group,
  $owner  = $trafficserver::group,
) {
  concat::fragment { "ensure ${path} ${ensure} in device file":
    ensure  => $ensure,
    target  => $trafficserver::params::device_file,
    content => template($trafficserver::params::device_template),
    notify  => Exec['update udev rules'],
  }
}
