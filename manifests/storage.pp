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

# This class assembles storage.config
define trafficserver::storage (
  $ensure  = 'present',
  $path    = $title,
  $size    = undef,
  $comment = undef,
  $group   = $trafficserver::group,
  $owner   = $trafficserver::user,
){

  validate_re($ensure, '^(present|absent)$')

  concat::fragment { "ensure ${title} ${ensure} in storage.config":
    ensure  => $ensure,
    target  => $trafficserver::params::storage_config,
    content => template($trafficserver::params::storage_template),
  }

  $provider = $size? {
    /^\d+[MGTPE]?$/ => 'mkdir',
    default      => $::kernel,
  }

  create_resources("trafficserver::storage::${::provider}", {
    "ensure ${title} is ${ensure} through ${provider}" => {
      'ensure' => $ensure,
      'path'   => $path,
      'size'   => $size,
      'owner'  => $owner,
      'group'  => $group,
    }
  })
}
