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

# setup of concat for ssl_multicert.config
class trafficserver::ssl {

  include 'concat::setup'
  include 'trafficserver::params'
  include 'trafficserver'

  $user  = $trafficserver::real_user
  $group = $trafficserver::real_group

  $configfile  = "${trafficserver::real_sysconfdir}/${trafficserver::params::ssl_config}"
  $conf_header = $trafficserver::params::ssl_config_header

  # creates the configuration
  concat { $configfile:
    owner   => $user,
    group   => $group,
  }

  concat::fragment { "${configfile}_header":
    target => $configfile,
    source => $conf_header,
    order  => '00000',
  }
}
