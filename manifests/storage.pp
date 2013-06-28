# This class assembles storage.config
class trafficserver::storage {

  include 'trafficserver::params'
  include 'trafficserver'

  $sysconfdir     = $trafficserver::real_sysconfdir
  $storage_passed = $trafficserver::real_storage

  $storage = $storage_passed ? {
    false   => [], # Someone genuinly passed a false, and wants to disable storage.
    default => $storage_passed,
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
