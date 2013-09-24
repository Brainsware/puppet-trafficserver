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

# This type handles adding ssl "vhosts" to ssl_multicert.config
#     ssl_host          => {
#       'dest_ip'       => '*',
#       'ssl_cert_name' => 'bar.pem',
#       'ssl_key_name'  => 'barKey.pem',
#       'ssl_ca_name'   => 'Ca.pem'
#     },
define trafficserver::config::ssl (
  $ssl_host,
){
  include 'concat::setup'
  include 'trafficserver::params'
  include 'trafficserver'
  
  $user  = $trafficserver::real_user
  $group = $trafficserver::real_group

  $sysconfdir = $trafficserver::sysconfdir
  $configfile = "${sysconfdir}/${trafficserver::params::ssl_config}"
  $template   = $trafficserver::params::ssl_config_template
  $comment    = $title

  validate_hash ( $ssl_host )
  unless has_key ($ssl_host, 'ssl_cert_name') {
    fail('\$ssl_hosts does not contain a key ssl_cert_name.')
  }
  
  # creates the configuration
  concat { "${configfile}":
    owner   => $user,
    group   => $group;
  }
  
  # concat the configuration
  concat::fragment { "${sysconfdir}/ssl_multicert.config_${comment}":
    target  => $configfile,
    content => template($template),
    order   => '99999',
    notify  => Exec[trafficserver-config-reload],
  }
}
