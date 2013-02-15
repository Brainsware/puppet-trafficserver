class trafficserver::install {
  package { [ 'trafficserver', 'trafficserver-gzip' ]:
    ensure => 'latest',
  }
}
