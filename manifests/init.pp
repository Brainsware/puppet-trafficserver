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
  $ssl         = UNDEF,
  $user        = UNDEF,
  $group       = UNDEF,
  $debug       = UNDEF,
  $mode        = UNDEF,
  $records     = UNDEF,
  $storage     = UNDEF,
  $prefix      = $trafficserver::params::prefix,
  $bindir      = "${prefix}/bin",
  $sysconfdir  = $trafficserver::params::sysconfdir,
  $cachedir    = $trafficserver::params::cachedir,
  $ssl_default = $trafficserver::params::ssl_default,
) inherits trafficserver::params {

  $real_ssl = $ssl? {
    UNDEF   => $trafficserver::params::ssl,
    default => $ssl,
  }

  $real_group = $group? {
    UNDEF   => $trafficserver::params::group,
    default => $group,
  }
  $real_user = $user? {
    UNDEF   => $trafficserver::params::user,
    default => $user,
  }

  $real_debug = $debug? {
    UNDEF   => $trafficserver::params::debug,
    default => $debug,
  }

  $real_storage = $storage? {
    UNDEF   => $trafficserver::params::storage,
    default => $storage,
  }

  $real_ssl_default = $ssl_default? {
    UNDEF   => $trafficserver::params::ssl_default,
    default => $ssl_default,
  }

  # for consistency, prefix this one with real_ also ;)
  if $real_ssl == true {
    $real_port = $trafficserver::params::listen_ssl
  } else {
    $real_port = $trafficserver::params::listen
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
