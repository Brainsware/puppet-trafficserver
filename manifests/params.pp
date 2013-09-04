# Sane default parameters for Traffic Server are held in this
# class -- they are also documented here!
class trafficserver::params {
  # Basic configurations

  $listen = '80'
  # To enable ssl termination also, we set this to:
  $listen_ssl = '80 443:ssl'

  $user  = 'tserver'
  $group = 'tserver'

  $debug = '3'  # default (highest).
  # Can go from 0 (disabled) to 3.
  # It's applied to both, in coming and outgoing Via headers.

  $records = []
  # Other records config options. Use augeas syntax here directly
  # While we generally consider records.config to be a "global", per
  # instance setting, it might be cleaner to simply use the defined type
  # trafficserver::config::records for these settings.
  #
  # Example:
  #
  # $records = [
  #   'set proxy.config.url_remap.pristine_host_hdr 1'
  # ]


  # Should we ever start supporting OS X or Windows, we can make this
  # platform dependent!
  $plugin_extension = 'so'


  # Traffic Server, mode of operations
  # These settings here directly translate into augeas settings.
  $mode_reverse = [
      'set proxy.config.url_remap.remap_required 1',
      'set proxy.config.reverse_proxy.enabled 1',
    ]
  $mode_forward = [
      'set proxy.config.url_remap.remap_required 0',
      'set proxy.config.reverse_proxy.enabled 0',
    ]
  $mode_both = [
      'set proxy.config.url_remap.remap_required 0',
      'set proxy.config.reverse_proxy.enabled 1',
    ]
  # Default mode of operation:
  $mode = 'reverse'
  $valid_modes = '^(reverse|forward|both)$'


  $ssl                = false
  $ssl_config         = 'ssl_multicert.config'
  $ssl_config_header  = 'puppet:///modules/trafficserver/ssl_multicert_header'
  $ssl_config_template= 'trafficserver/ssl_multicert.config.erb'
  $ssl_default = {}

  case $::operatingsystem {
    '/(Darwin|FreeBSD)/': {
      $prefix     = '/usr/local'
      $sysconfdir = "${prefix}/etc/trafficserver"
      $cachedir   = "${prefix}/var/cache/trafficserver"
      $bindir     = "${prefix}/bin"
    }
    default: {
      $prefix     = '/usr'
      $sysconfdir = '/etc/trafficserver'
      $cachedir   = '/var/cache/trafficserver'
      $bindir     = "${prefix}/bin"
    }
  }

  $storage = { "${cachedir}" => '512M' }
  # array of storage devices or directories. Each entry
  # contains a config line as per storage.config. E.g.:
  #
  # $storage = [ '/dev/vdb', '/dev/vdc' ]
  #
  # It should be noted, that if we give trafficserver access to
  # disk device files, we also need to make sure udev gives the
  # trafficserver group (tserver) write access to these:
  #
  # SUBSYSTEM=="block", KERNEL=="vd[bc]", GROUP:="tserver"
}
