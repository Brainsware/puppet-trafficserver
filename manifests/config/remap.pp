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

# This type handles adding values to remap.config
# array of url maps or redirects. Each entry corresponds
# to a line in remap.config. n.b.: The traffic server
# internal order of processing is: redirects, maps, regex remaps
#
# Example:
#
# redirect = {
#     'http://www.example.org' => 'http://example.org',
#     'http://git.example.org' => 'https://git.example.org',
#   },
#   # n.b.: We allow all methods on git.
# url_map = {
#     # This currently doesn't work:
#     # @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
#     'https://git.example.org' => 'http://app05-dev.rz01.riseops.at:9002',
#   },
# reverse_map = {
#    'http://app04-dev.dev.rz01.riseops.at:9001' => 'http://example.org',
# }
#   # map everything else to:',
# regex_map = {
#     @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
#     'http://.*\.dev.example\.org' => 'http://app06-dev.rz01.riseops.at:8000',
#     @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
#     'https://.*\.dev.example\.org' => 'http://app06-dev.rz01.riseops.at:8000,
#   }
# trafficserver::config::remap { 'example.com-remaps':
#   map     => $url_map,
#   rev_map => $reverse_map,
# }
# trafficserver::config::remap { 'example.com-redirects':
#   redirect => $redirect,
# }
# trafficserver::config::remap { 'example.com-regex':
#   regex_map => $regex_map,
# }
#
define trafficserver::config::remap (
  $map       = {},
  $rev_map   = {},
  $regex_map = {},
  $redirect  = {},
) {

  include 'trafficserver'
  include 'trafficserver::params'

  $sysconfdir = $trafficserver::sysconfdir
  $configfile = "${sysconfdir}/remap.config"

  $lens    = 'Trafficserver_remap.lns'
  $context = "/files${configfile}"
  $incl    = $configfile
  $comment = $title


  augeas { "${lens}_${comment}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes => template('trafficserver/remap.config.erb'),
    notify  => Exec[trafficserver-config-reload],
  }
}
