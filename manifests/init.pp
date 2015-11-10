#   Copyright 2013 Brainsware
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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
  $listen      = $trafficserver::params::listen,
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
  $install     = $trafficserver::params::install,
) inherits trafficserver::params {

  $port = $ssl? {
    true    => $trafficserver::params::listen_ssl,
    default => $listen,
  }
  validate_re ($mode, $valid_modes)

  if $install == true {
    include 'trafficserver::install'
  }
  include 'trafficserver::config'
  include 'trafficserver::service'

  if $install == true {
    anchor { 'traffiserver::begin': } ->
    Class['trafficserver::install'] ->
    Class['trafficserver::config'] ->
    Class['trafficserver::service'] ->
    anchor { 'trafficserver::end': }
  }
  else {
    anchor { 'traffiserver::begin': } ->
    Class['trafficserver::config'] ->
    Class['trafficserver::service'] ->
    anchor { 'trafficserver::end': }
  }
}
