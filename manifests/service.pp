# This class ensures the service is running, and can be notified
# for config changes
class trafficserver::service {
  service { 'trafficserver':
    ensure   => 'running',
  }
}
