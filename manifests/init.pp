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
#     ssl                            => true,
#     storage                        => [ '/dev/vdb' ],
#     plugins                  => {
#         'stats_over_http.so' => '',
#         'gzip.so'            => 'gzip.config',
#     }
#     ssl_default         => {
#       'ssl_cert_name' => 'bar.pem',    'ssl_key_name' => 'barKey.pem'
#     },
#   }
#
#
#
class trafficserver (
  $ssl         = $trafficserver::params::ssl,
  $user        = $trafficserver::params::user,
  $group       = $trafficserver::params::group,
  $debug       = $trafficserver::params::debug,
  $mode        = $trafficserver::params::mode,
  $plugins     = $trafficserver::params::plugins,
  $records     = $trafficserver::params::records,
  $storage     = $trafficserver::params::storage,
  $sysconfdir  = $trafficserver::params::sysconfdir,
  $cachedir    = $trafficserver::params::cachedir,
  $ssl_default   = $trafficserver::params::ssl_default,
) inherits trafficserver::params {

  if $ssl == true {
    $port = $trafficserver::params::listen_ssl
  } else {
    $port = $trafficserver::params::listen
  }

  include 'trafficserver::install'
  include 'trafficserver::config'
  include 'trafficserver::service'

  anchor { 'traffiserver::begin': } ->
  Class['trafficserver::install'] ->
  Class['trafficserver::config'] ~>
  Class['trafficserver::service'] ->
  anchor { 'trafficserver::end': }
}
