class trafficserver::service {

  service { 'trafficserver':
    ensure   => 'running',
    provider => 'upstart',
  }

}
