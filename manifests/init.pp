# == Class: trafficserver
#
# Install and configure trafficserver.
#
# === Parameters
#
# All parameters are documented in trafficserver::params
#
# === Examples
#
#   class {'trafficserver':
#     port                           => '80 443:ssl'
#     storage                        => [ '/dev/vdb' ],
#     url_map                        => [
#       { 'http://pypi.es.at/pypi'   => 'https://pypi.python.org/pypi' },
#       { 'http://pypi.es.at'        => 'http://c.pypi.python.org' },
#       { 'http://mypypi.risedev.at' => 'http://localhost:8080' }
#     ],
#     url_reverse_map                         => [
#       { 'http://localhost:8080'           => 'http://mypypi.risedev.at' },
#       { 'https://pypi.python.org' => 'http://pypi.es.at' },
#     ],
#     records => [ 'set proxy.config.url_remap.pristine_host_hdr 0' ]
#   }
#
#
#
class trafficserver (
  $ssl             = false,
  $user            = $trafficserver::params::user,
  $group           = $trafficserver::params::group,
  $debug           = $trafficserver::params::debug,
  $mode            = $trafficserver::params::mode,
  $plugins         = $trafficserver::params::plugins,
  $storage         = $trafficserver::params::storage,
  $records         = $trafficserver::params::records,
  $url_redirect    = $trafficserver::params::url_redirect,
  $url_map         = $trafficserver::params::url_map,
  $url_reverse_map = $trafficserver::params::url_reverse_map,
  $url_regex_map   = $trafficserver::params::url_regex_map,
) inherits trafficserver::params {

  include 'trafficserver::install'
  include 'trafficserver::config'
  include 'trafficserver::service'

  if $ssl {
    $port = $trafficserver::params::port
  } else {
    $port = $trafficserver::params::ssl_port
  }

  anchor { 'traffiserver::begin': } ->
  Class['trafficserver::install'] ->
  Class['trafficserver::config'] ~>
  Class['trafficserver::service'] ->
  anchor { 'trafficserver::end': }
}
