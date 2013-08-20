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

  # we can take either [ '/dev/sdc', '/dev/sdb'] or
  # { '/var/cache/ats' => '4GB', } with this augeas template:
  augeas { 'trafficserver.storage':
    lens    => 'Trafficserver_storage.storage_lns',
    context => "/files${sysconfdir}/storage.config",
    incl    => "${sysconfdir}/storage.config",
    changes => template('trafficserver/storage.config.erb'),
  }

  # However, we only want to execute these Udev rules, if we got a non-empty array:
  if is_array($storage) and $storage {
    Exec {
      path => '/bin:/usr/bin:/sbin:/usr/sbin',
      cwd  => '/',
    }
    file { '/etc/udev/rules.d/51-cache-disk.rules':
      content => template('trafficserver/51-cache-disk.rules.erb'),
      notify  => Exec['update udev rules'],
    }

    # trigger an update of udev rules of the block subsystem
    exec { 'update udev rules':
      command     => 'udevadm trigger --subsystem-match=block',
      refreshonly => true,
    }
  }
}
