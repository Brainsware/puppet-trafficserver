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

# This define assembles remap.config
define trafficserver::remap (
  $ensure           = 'present',
  $type             = 'map',
  $activatefilter   = undef,
  $deactivatefilter = undef,
  $config           = [],
  $order            = undef,
){

  validate_re($ensure, '^(present|absent)$')
  validate_re($type, '^(regex_)?(map|map_with_referer|map_with_recv_port|reverse_map|redirect|redirect_temporary)$')

  if empty($activatefilter) and empty($deactivatefilter) and empty($config) {
    fail("Trafficserver::remap[${title}]: one of activatefilter, deactivatefilter, config must be set!")
  }

  ## derrive concat order from $type, or else, use $order
  if $order {
    $real_order = $order
  } else {
    $real_order = $type? {
      # http://trafficserver.readthedocs.org/en/latest/reference/configuration/remap.config.en.html#precedence
      'map_with_recv_port'       => 10,
      'regex_map_with_recv_port' => 10,
      'map'                      => 20,
      'regex_map'                => 20,
      'reverse_map'              => 20,
      'map_with_referer'         => 20,
      'regex_map_with_referer'   => 20,
      'redirect'                 => 30,
      'redirect_temporary'       => 30,
      'regex_redirect'           => 40,
      'regex_redirect_temporary' => 40,
      default                    => 20, # our default is same as map/regex_remap/reverse_map
    }
  }

  # used variables in this template
  # * config
  # * type
  # * activatefilter
  # * deactivatefilter
  concat::fragment { "ensure ${title} ${ensure} in remap.config":
    ensure  => $ensure,
    order   => $real_order,
    target  => $trafficserver::params::remap_config,
    content => template($trafficserver::params::remap_template),
  }

}
