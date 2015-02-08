# basic (concat) setup for trafficserver remap
class trafficserver::config::remap {

  # these variables will also be used in the udev file header
  $owner = $trafficserver::user
  $group = $trafficserver::group

  concat { $trafficserver::params::remap_config:
    owner  => $owner,
    group  => $group,
    notify => Exec['trafficserver-config-reload'],
  }

  concat::fragment { 'remap_header':
    order   => '00',
    target  => $trafficserver::params::remap_config,
    content => template($trafficserver::params::remap_header),
  }
}
