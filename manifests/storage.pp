class trafficserver::storage {

  include 'trafficserver::params'

  Exec {
    path => '/bin:/usr/bin:/sbin:/usr/sbin',
    cwd  => '/',
  }

  augeas { 'trafficserver.storage':
    context => "/files/${trafficserver::sysconfdir}/storage.config",
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
