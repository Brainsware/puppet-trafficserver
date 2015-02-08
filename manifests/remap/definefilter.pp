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

# This define helps define filters in remap.config
define trafficserver::remap::definefilter (
  $filter,
  $ensure = 'present',
  # you can explicitly override the filter's name, by setting
  # name => 'something_else'
){

  validate_re($ensure, '^(present|absent)$')

  # used variables in this template
  # * name
  # * filter
  concat::fragment { "ensure ${name} filter ${ensure} in remap.config":
    ensure  => $ensure,
    order   => '05',
    target  => $trafficserver::params::remap_config,
    content => template($trafficserver::params::definefilter_template),
  }
}
