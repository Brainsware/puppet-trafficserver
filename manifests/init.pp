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
  $ssl         = UNDEF,
  $user        = UNDEF,
  $group       = UNDEF,
  $debug       = UNDEF,
  $mode        = UNDEF,
  $plugins     = UNDEF,
  $records     = UNDEF,
  $storage     = UNDEF,
  $sysconfdir  = UNDEF,
  $cachedir    = UNDEF,
  $ssl_default   = $trafficserver::params::ssl_default,
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

  $real_plugins = $plugins? {
    UNDEF   => $trafficserver::params::plugins,
    default => $plugins,
  }

  $real_storage = $storage? {
    UNDEF   => $trafficserver::params::storage,
    default => $storage,
  }

  $real_sysconfdir = $sysconfdir? {
    UNDEF   => $trafficserver::params::sysconfdir,
    default => $sysconfdir,
  }
  $real_cachedir = $cachedir? {
    UNDEF   => $trafficserver::params::cachedir,
    default => $cachedir,
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
