# Puppet Module for Apache Traffic Server 

manage installation and configuration of Apache Traffic Server.

Currently supported modes: Forward, Reverse and mixed.
Supported Platforms: Debian/Ubuntu, FreeBSD: partially. Solaris/Illumos: untested.

It allows to seperately configure plugins, SSL certs and Remap Rules. Storage is configured globally.

This plugin assumes that you have current version of Apache Traffic Server in your packagemanager's repositories. See [fpm](https://github.com/jordansissel/fpm) for a project that allows you to easily create packages.

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
     class { 'trafficserver':
       prefix     => '/opt/es',
       sysconfdir => '/etc/es/trafficserver',
       user       => 'ats-cache'
       storage    => [ '/dev/sdc', '/dev/sdd', '/dev/sde', '/dev/sdf' ],
     }
```

## Plugins

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

## Remap

Configure a couple of remaps:

```puppet
     $map = {
       'http://example.com' => 'http://backend-web01',
       'http://example.org' => 'http://backend-web21',
       'http://example.net' => 'http://backend-web42',
     }
     $rev_map = {
       'http://backend-web01' => 'http://example.com',
       'http://backend-web21' => 'http://example.org',
       'http://backend-web42' => 'http://example.net',
     }
     $redirect = {
       'http://example.co.uk' => 'http://example.com/uk',
     }
     trafficserver::config::remap { 'example_maps':
       map         => $map,
       rev_map     => $rev_map,
       redirect    => $redirect,
     }
```

## SSL

Similarily to remap, we can can setup multiple SSL virtual hosts.

There are two ways to specify more than one virtual host. We can either make multiple calls to `trafficserver::config::ssl`:

```puppet
    $www = {
      'ssl_cert_name' => '/etc/ssl/certs/www.example.com.crt',
      'ssl_key_name' => '/etc/ssl/certs/mail.example.com.key',
    }
    $mail = {
      'ssl_cert_name' => '/etc/ssl/certs/mail.example.com.crt',
      'ssl_key_name' => '/etc/ssl/keys/mail.example.com.key',
    }
    trafficserver::config::ssl { 'www.example.com':
      ssl_host => $www
    }
    trafficserver::config::ssl { 'mail.example.com':
      ssl_host => $mail
    }
```

or we pass it an array:

```puppet
    example_com = [{
      'ssl_cert_name' => '/etc/ssl/certs/www.example.com.crt',
      'ssl_key_name' => '/etc/ssl/certs/mail.example.com.key',
    },{
      'ssl_cert_name' => '/etc/ssl/certs/mail.example.com.crt',
      'ssl_key_name' => '/etc/ssl/keys/mail.example.com.key',
    }]
    trafficserver::config::ssl { '*.example.com':
      ssl_hosts => $example_com
    }
```

## TODO

* I'd like to have a test case for every single thing that we have documented above.
* Right now, `@action`s/`@flter`s/etc.. in remap rules are not supported.
* Add reload hook for storage on FreeBSD device changes

## Release process

The version in Modulefile should be bumped according to [semver](http://semver.org/) *during development*, i.e.: The first commit after the release should already bump the version, as master at this point differs from the latest release.

When cutting a new release, please

* make sure that all tests pass
* make sure that the documentation is up-to-date
* verify that all dependencies are correct, and up-to-date
* create a new, *signed* tag and a package, using `rake release`:

```
    igalic@levix ~/src/bw/puppet-trafficserver (git)-[master] % rake release
    git tag -s 1.3.2 -m 't&r 1.3.2'
    ...
    git checkout 1.3.2
    Note: checking out '1.3.2'.
    ...
    HEAD is now at ff9aaae... Most awesomest feature ever. SHIPIT!
    puppet module build .
    Notice: Building /home/igalic/src/bw/puppet-trafficserver for release
    Module built: /home/igalic/src/bw/puppet-trafficserver/pkg/brainsware-trafficserver-1.3.2.tar.gz
    igalic@levix ~/src/bw/puppet-trafficserver (git)-[1.3.2] %
```

* push the tag,

```
    igalic@levix ~/src/bw/puppet-trafficserver (git)-[1.3.2] % git push --tags origin
```

* and finally [upload the new package](http://forge.puppetlabs.com/brainsware/trafficserver/upload)

License
-------

Apache Software License 2.0


Contact
-------

You can send us questions via mail [puppet@brainsware.org](puppet@brainsware.org), or reach us IRC: [igalic](https://github.com/igalic) hangs out in [#puppet](irc://freenode.org/#puppet)

Support
-------

Please log tickets and issues at our [Project's issue tracker](https://github.com/Brainsware/puppet-trafficserver/issues)
