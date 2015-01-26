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

# Sane default parameters for Traffic Server are held in this
# class -- they are also documented here!
class trafficserver::params {
  # Basic configurations

  $package_name           = 'trafficserver'
  $package_ensure         = 'present'
  $plugins_package_name   = 'trafficserver-experimental-plugins'
  $plugins_package_ensure = 'present'

  $service_name   = 'trafficserver'
  $service_ensure = 'running'
  $service_enable =  true

  $ssl         = false
  $listen      = '80:ipv4 80:ipv6'
  # To enable ssl termination also, we set this to:
  $listen_ssl  = "${listen} 443:ssl:ipv4 443:ssl:ipv6"

  # this will be used "via" debugging:
  $debug       = '3'

  # Traffic Server, mode of operations
  # Default mode of operation:
  $mode        = 'reverse'
  $valid_modes = '^(reverse|forward|both)$'

  $user  = 'trafficserver'
  $group = 'trafficserver'

  case $::operatingsystem {
    '/(Darwin|FreeBSD)/': {
      $prefix     = '/usr/local'
      $sysconfdir = "${prefix}/etc/trafficserver"
      $cachedir   = "${prefix}/var/cache/trafficserver"
      $bindir     = "${prefix}/bin"
    }
    default: {
      $device_file     = '/etc/udev/rules.d/51-cache-disk.rules'
      $device_header   = "${module_name}/51-cache-disk.header.erb"
      $device_template = "${module_name}/51-cache-disk.rules.erb"
      $prefix      = '/usr'
      $sysconfdir  = '/etc/trafficserver'
      $cachedir    = '/var/cache/trafficserver'
      $bindir      = "${prefix}/bin"
    }
  }
  $storage_config   = "${sysconfdir}/storage.config"
  $storage_header   = "${module_name}/storage.config.header.erb"
  $storage_template = "${module_name}/storage.config.erb"
}
