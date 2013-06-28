# This class assembles storage.config
class trafficserver::storage {

  include 'trafficserver::params'
  include 'trafficserver'

  $sysconfdir     = $trafficserver::sysconfdir
  $storage_passed = $trafficserver::storage

  if $storage_passed == {} or $storage_passed == [] or $storage_passed == UNDEF {
    # Nothing was passed, we're dealing with empty default values, reset to *actual* default
    $storage = $trafficserver::params::storage
  } elsif $storage_passed == false {
    # Someone genuinly passed a false, and wants to disable storage.
    $storage  = {}
  }

  Exec {
    path => '/bin:/usr/bin:/sbin:/usr/sbin',
    cwd  => '/',
  }

  augeas { 'trafficserver.storage':
    lens    => 'Trafficserver_storage.storage_lns',
    context => "/files${sysconfdir}/storage.config",
    incl    => "${sysconfdir}/storage.config",
    changes => template('trafficserver/storage.config.erb'),
  }
  file { '/etc/udev/rules.d/51-cache-disk.rules':
    content => template('trafficserver/51-cache-disk.rules.erb'),
    notify  => Exec['update udev rules'],
  }

  exec { 'update udev rules':
    command     => 'udevadm control --start-exec-queue',
    refreshonly => true,
  }
}
