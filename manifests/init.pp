#   Copyright 2015 Brainsware
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
#   class {'trafficserver': }
#
#   # plugins can be configured like this:
#   trafficserver_plugin { 'stats_over_http': }
#   trafficserver_plugin { 'gzip':
#     arguments => '/etc/bw/trafficserver/gzip.config',
#   }
#   trafficserver_plugin { 'foo_plugin':
#     arguments => [ 'foo', 'bar', ]
#   }
#
#
#
class trafficserver (
  # manage the package.
  # If you don't want that, you can set all of these as [] and 'undef'
  # in hiera that is acomplished with:
  #
  #    trafficserver::package_name  : []
  #    trafficserver::package_ensure: !!null
  #
  $package_name           = $trafficserver::params::package_name,
  $package_ensure         = $trafficserver::params::package_ensure,
  $plugins_package_name   = $trafficserver::params::plugins_package_name,
  $plugins_package_ensure = $trafficserver::params::plugins_package_ensure,

  $service_name   = $trafficserver::params::service_name,
  $service_ensure = $trafficserver::params::service_ensure,
  $service_enable = $trafficserver::params::service_enable,

  # ~some~ configuration parameters
  $ssl    = $trafficserver::params::ssl,
  $listen = $trafficserver::params::listen,
  $mode   = $trafficserver::params::mode,
  $debug  = $trafficserver::params::debug,

  # change base assumptions here to support your favourite OS
  # because our params.pp does not know it
  $user       = $trafficserver::params::user,
  $group      = $trafficserver::params::group,
  $prefix     = $trafficserver::params::prefix,
  $bindir     = "${prefix}/bin",
  $sysconfdir = $trafficserver::params::sysconfdir,
  $cachedir   = $trafficserver::params::cachedir,
) inherits trafficserver::params {

  validate_re ($mode, $trafficserver::params::valid_modes)

  include 'trafficserver::install'
  include 'trafficserver::config'
  include 'trafficserver::service'

  anchor { 'traffiserver::begin': } ->
  Class['trafficserver::install'] ->
  Class['trafficserver::config'] ->
  Class['trafficserver::service'] ->
  anchor { 'trafficserver::end': }
}
