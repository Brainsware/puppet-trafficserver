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

  $mode = 'reverse' # default.
  # Other options: 'forward', 'both'.
  # Transparent proxy is currently not supported by this module

  $records = []
  # Other records config options. Use augeas syntax here directly
  #
  # Example:
  #
  # $records = [
  #   'set proxy.config.url_remap.pristine_host_hdr 1'
  # ]

  $plugins = {}
  # This an array of plugin names, e.g.:
  # $plugins = ['http_stats.so', 'gzip.so']
  #
  # It can also include the plugin's config:
  # $plugins = [
  #   'http_stats.so',
  #   'gzip.so' => 'gzip.config',
  #   'foo.so'  => 'foo bar baz',
  # ]

  $storage = []
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

  $redirects   = {}
  $url_map     = {}
  $reverse_map = {}
  $regex_map   = {}
  # array of url maps or redirects. Each entry corresponds
  # to a line in remap.config. n.b.: The traffic server
  # internal order of processing is: redirects, maps, regex remaps
  #
  # Example:
  #
  # $redirects = {
  #     'http://www.example.org' => 'http://example.org',
  #     'http://git.example.org' => 'https://git.example.org',
  #   },
  #   # n.b.: We allow all methods on git.
  # $url_map => {
  #     # This currently doesn't work:
  #     # 'http://example.org http://app04-dev.dev.rz01.riseops.at:9001 @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
  #     'https://git.example.org' => 'http://app05-dev.rz01.riseops.at:9002',
  #   },
  # $reverse_map => {
  #    'http://app04-dev.dev.rz01.riseops.at:9001' => 'http://example.org',
  # }
  #   # map everything else to:',
  # $regex_map => {
  #     'http://.*\.dev.example\.org' => 'http://app06-dev.rz01.riseops.at:8000', }, # @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
  #     'https://.*\.dev.example\.org' => 'http://app06-dev.rz01.riseops.at:8000, }, # @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
  #   },
  #

  $ssl_hosts = []

  case $::operatingsystem {
    '/(Darwin|FreeBSD)/': { $sysconfdir = '/usr/local/etc/trafficserver' }
    default: { $sysconfdir = '/etc/trafficserver' }
  }
}
