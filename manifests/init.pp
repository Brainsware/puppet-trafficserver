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
#     ssl_default         => {
#       'ssl_cert_name' => 'bar.pem',    'ssl_key_name' => 'barKey.pem'
#     },
#   }
#
#   # plugins can be configured like this:
#   trafficserver::config::plugin { 'stats_over_http': }
#   trafficserver::config::plugin { 'gzip':
#     args => '/etc/bw/trafficserver/gzip.config',
#   }
#   trafficserver::config::plugin { 'foo_plugin':
#     args => [
#       'foo',
#       'bar',
#     ]
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
  $prefix      = $trafficserver::params::prefix,
  $bindir      = "${prefix}/bin",
  $sysconfdir  = $trafficserver::params::sysconfdir,
  $cachedir    = $trafficserver::params::cachedir,
  $storage     = $trafficserver::params::storage,
  $ssl_default = undef,
  $records     = undef,
) inherits trafficserver::params {

  $port = $ssl? {
    true    => $trafficserver::params::listen_ssl,
    default => $trafficserver::params::listen,
  }

  include 'trafficserver::install'
  include 'trafficserver::config'
  include 'trafficserver::service'

  anchor { 'traffiserver::begin': } ->
  Class['trafficserver::install'] ->
  Class['trafficserver::config'] ->
  Class['trafficserver::service'] ->
  anchor { 'trafficserver::end': }
}
