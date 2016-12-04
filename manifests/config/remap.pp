# basic (concat) setup for trafficserver remap
class trafficserver::config::remap {

  # these variables will also be used in the udev file header
  $owner = $trafficserver::user
  $group = $trafficserver::group

  concat { $trafficserver::params::remap_config:
    owner  => $owner,
    group  => $group,
    order  => 'numeric',
    notify => Class[trafficserver::service],
  }

  concat::fragment { 'remap_header':
    order   => 0,
    target  => $trafficserver::params::remap_config,
    content => template($trafficserver::params::remap_header),
  }
}
