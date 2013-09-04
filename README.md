# Puppet Module for Apache Traffic Server 

manage installation and configuration of Apache Traffic Server.

Currently supported modes: Forward, Reverse and mixed.
Supported Platforms: Debian/Ubuntu.

It allows to seperately configure plugins, SSL certs and Remap Rules. Storage is configured globally.

This plugin assumes that you have current version of Apache Traffic Server in your packagemanager's repositories. See [fpm](https://github.com/jordansissel/fpm) for a project that allows you to easily create packages.

## Documentation

Installing Traffic Server:

``` puppet
     include trafficserver
```

Installing Traffic Server, enabling SSL.

```puppet
     class { 'trafficserver':
       ssl => true,
     }
```

Install it in some weird prefix:

```puppet
     class { 'trafficserver':
       prefix     => '/opt/es',
       sysconfdir => '/etc/es/trafficserver',
     }
```

Install it, assign a couple of disks:

```puppet
     storage = class { 'trafficserver':
     class { 'trafficserver':
       prefix     => '/opt/es',
       sysconfdir => '/etc/es/trafficserver',
       user       => 'ats-cache'
       storage    => [ '/dev/sdc', '/dev/sdd', '/dev/sde', '/dev/sdf' ],
     }
```

Configure [gzip](https://trafficserver.readthedocs.org/en/latest/reference/plugins/gzip.en.html) plugin:

```puppet
     trafficserver::config::plugin { 'gzip':
       args => '/etc/es/trafficserver/gzip.config'
     }
```

Configure [stats\_over\_http](https://trafficserver.readthedocs.org/en/latest/reference/plugins/stats_over_http.en.html) plugin. Really, this should be some default:

```puppet
     trafficserver::config::plugin { 'stats_over_http': }
```

Configure a couple of remaps:

```puppet
     $map = {
       'http://example.com' => 'http://backend-web01',
       'http://example.org' => 'http://backend-web21',
       'http://example.net' => 'http://backend-web42',
     }
     $reverse_map = {
       'http://backend-web01' => 'http://example.com',
       'http://backend-web21' => 'http://example.org',
       'http://backend-web42' => 'http://example.net',
     }
     $redirect = {
       'http://example.co.uk' => 'http://example.com/uk',
     }
     trafficserver::config::remap { 'example_maps':
       map         => $map,
       reverse_map => $reverse_map,
       redirect    => $redirect,
     }
```

## TODO

* I'd like to have a test case for every single thing that we have documented above.
* Right now, `@action`s/`@flter`s/etc.. in remap rules are not supported.
* Add reload hook for storage on FreeBSD device changes


License
-------

Apache Software License 2.0


Contact
-------


Support
-------

Please log tickets and issues at our [Projects site](http://brainsware.org/)
