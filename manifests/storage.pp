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

# This class assembles storage.config
class trafficserver::storage inherits trafficserver {

  $storage_passed = $trafficserver::storage

  $storage = $storage_passed ? {
    false   => [], # Someone genuinly passed a false, and wants to disable storage.
    default => $storage_passed,
  }

  # we can take either [ '/dev/sdc', '/dev/sdb'] or
  # { '/var/cache/ats' => '4GB', } with this augeas template:
  augeas { 'trafficserver.storage':
    lens    => 'Trafficserver_storage.lns',
    context => "/files${sysconfdir}/storage.config",
    incl    => "${sysconfdir}/storage.config",
    changes => template('trafficserver/storage.config.erb'),
  }

  # However, we only want to execute these Udev rules, if we got a non-empty array:
  if is_array($storage) and $storage {
    Exec {
      path => '/bin:/usr/bin:/sbin:/usr/sbin',
      cwd  => '/',
    }
    if $::kernel == 'Linux' {
      file { '/etc/udev/rules.d/51-cache-disk.rules':
        content => template('trafficserver/51-cache-disk.rules.erb'),
        notify  => Exec['update udev rules'],
      }

      # trigger an update of udev rules of the block subsystem
      exec { 'update udev rules':
        command     => 'udevadm trigger --subsystem-match=block',
        refreshonly => true,
      }
    }
  }
}
