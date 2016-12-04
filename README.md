# Puppet Module for Apache Traffic Server 

manage installation and configuration of Apache Traffic Server.

Currently supported modes: Forward, Reverse and mixed.
Supported Platforms: Debian/Ubuntu, FreeBSD: partially. Solaris/Illumos: untested.

It allows to separately configure plugins, SSL certs and Remap Rules. Storage is configured globally.

This plugin assumes that you have current version of Apache Traffic Server in your packagemanager's repositories. See my [ppa](https://launchpad.net/~apache-helpdesk/+archive/ubuntu/trafficserver-ppa) for a current version for all Ubuntu LTSes.

# Documentation

## Install Traffic Server

```puppet
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
include ::trafficserver
trafficserver::storage { '/dev/sda': }
trafficserver::storage { '/dev/sdb': }
```

Maybe you would prefer to keep cache in a directory on one disk:

```puppet
trafficserver::storage { '/var/cache/trafficserver': }
```

## Plugins

Configure [gzip](https://trafficserver.readthedocs.org/en/latest/reference/plugins/gzip.en.html) plugin:

```puppet
trafficserver_plugin { 'gzip.so':
  arguments => '/etc/trafficserver/gzip.config'
}
```

Configure [stats\_over\_http](https://trafficserver.readthedocs.org/en/latest/reference/plugins/stats_over_http.en.html) plugin. Really, this should be some default:

```puppet
trafficserver_plugin { 'stats_over_http.so': }
```

Configure [balancer](https://trafficserver.readthedocs.org/en/latest/reference/plugins/balancer.en.html) plugin. Don't use `plugin` class. Configure a couple of balancer map:


## Remap

Configure a couple of remaps:

```puppet
trafficserver::remap { 'example.com'
  from => 'http://example.com',
  to   => 'http://backend-web01',
}
trafficserver::remap { 'example.org
  from => 'http://example.org,
  to => 'http://backend-web21',
}
trafficserver::remap { 'example.net':
  from => 'http://example.net',
  to   => 'http://backend-web42',
}

trafficserver::remap { 'rev example.com':
  type => reverse_map,
  from => 'http://backend-web01',
  to   => 'http://example.com',
}
trafficserver::remap { 'rev example.org':
  type => reverse_map,
  from => 'http://backend-web21',
  to   => 'http://example.org',
}
trafficserver::remap { 'rev example.org':
  type => reverse_map,
  from => 'http://backend-web42'
  to   => 'http://example.net',
}

trafficserver::remap { 'redirect co.uk':
  type => redirect,
  from => 'http://example.co.uk',
  to   => 'http://example.com/uk',
}
```

## SSL

Similarily to remap, we can can setup multiple SSL virtual hosts.

```puppet
trafficserver_ssl_multicert { 'example.com':
  ssl_cert_name => 'www.example.com.crt',
  ssl_key_name  => 'www.example.com.key',
}
trafficserver_ssl_multicert { 'mail.example.com':
  ssl_cert_name => 'mail.example.com.crt',
  ssl_key_name  => 'mail.example.com.key',
}
```




## Filters

Using `trafficserver::remap::definefilter` we can define filters:

```puppet
trafficserver::remap::definefilter { 'title for disable_delete_purge':
  name   => 'disable_delete_purge',
  filter => [
    '@action=deny',
    '@method=delete',
    '@method=purge',
  ],
}

trafficserver::remap::definefilter { 'internal_only':
  filter => [
    '@action=allow',
    '@src_ip=192.168.0.1-192.168.0.254',
    '@src_ip=10.0.0.1-10.0.0.254',
  ],
}
```

…and then reuse them:

```puppet
trafficserver::remap { 'activate delete_purge':
  activatefilter => 'disable_delete_purge',
  order          => -1,
}

trafficserver::remap { 'foo to bar':
  from => 'http://foo.example.com/',
  to   => 'http://bar.example.com/',
}

trafficserver::remap { 'map admin (internal only)':
  activatefilter   => 'internal_only',
  from             => 'http://www.example.com/admin',
  to               => 'http://internal.example.com/admin',
  deactivatefilter => 'internal_only',
}

trafficserver::remap { 'example':
  from => 'http://www.example.com/',
  to   => 'http://internal.example.com/',
}
```

## Release process

When cutting a new release, please

* make sure that all tests pass
* make sure that the documentation is up-to-date
* verify that all dependencies are correct, and up-to-date
* create a new, *signed* tag and a package, using `rake travis_release`:


License
-------

Apache Software License 2.0


Contact
-------

You can send us questions via mail [puppet@brainsware.org](puppet@brainsware.org), or reach us IRC: [igalic](https://github.com/igalic) hangs out in [#puppet](irc://freenode.org/#puppet)

Support
-------

Please log tickets and issues at our [Project's issue tracker](https://github.com/Brainsware/puppet-trafficserver/issues)
