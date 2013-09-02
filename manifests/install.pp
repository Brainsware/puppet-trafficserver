# install traffic server
class trafficserver::install {
  package { 'trafficserver':
    ensure => 'latest',
  }
}
