# "private" defined type for platform specifics
define trafficserver::storage::mkdir (
  $ensure = 'present',
  $path   = $title,
  $size   = undef,
  $group  = $trafficserver::group,
  $owner  = $trafficserver::group,
) {
  # even if $ensure == absent, we do *not* remove this directory
  # traffic server promises a persistent cache. let's keep it that way
  file { $path:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    mode   => '0750',
  }
}
