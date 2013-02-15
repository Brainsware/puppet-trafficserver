# == Class: trafficserver
#
# Full description of class trafficserver here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { trafficserver:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class trafficserver {


}
class trafficserver (
  $port            = $trafficserver::params::port,
  $debug           = $trafficserver::params::debug,
  $mode            = $trafficserver::params::mode,
  $plugins         = $trafficserver::params::plugins,
  $storage         = $trafficserver::params::storage,
  $records         = $trafficserver::params::records,
  $url_redirect    = $trafficserver::params::url_redirect,
  $url_map         = $trafficserver::params::url_map,
  $url_reverse_map = $trafficserver::params::url_reverse_map,
  $url_regex_map   = $trafficserver::params::url_regex_map,
) inherits trafficserver::params {

  include 'trafficserver::install'
  include 'trafficserver::config'
  include 'trafficserver::service'

  anchor { 'traffiserver::begin': } ->
  Class['trafficserver::install'] ->
  Class['trafficserver::config'] ~>
  Class['trafficserver::service'] ->
  anchor { 'trafficserver::end': }
}
