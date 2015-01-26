# basic (concat) setup for trafficserver storage
# + platform specific execs, so we don't "duplicate" them in the defines
class trafficserver::config::storage {

  # these variables will also be used in the udev file header
  $owner = $trafficserver::user
  $group = $trafficserver::group

  concat { $trafficserver::params::storage_config:
    owner  => $owner,
    group  => $group,
    notify => Exec['trafficserver-config-reload'],
  }

  concat::fragment { 'storage_header':
    order   => '00',
    target  => $trafficserver::params::storage_config,
    content => template($trafficserver::params::storage_header),
  }

  # $::kernel specific device file
  concat { $trafficserver::params::device_file: }

  concat::fragment { 'device_file_header':
    order   => '00',
    target  => $trafficserver::params::device_file,
    content => template($trafficserver::params::device_header),
  }

  case $::kernel {
    'Linux': {
      exec { 'update udev rules':
        command     => 'udevadm trigger --subsystem-match=block',
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        cwd         => '/',
        refreshonly => true,
      }
    }
    default: {}
  }
}
