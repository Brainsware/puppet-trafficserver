# Puppet Module for Apache Traffic Server 

manage installation and configuration of Apache Traffic Server.

Currently supported modes: Forward, Reverse and mixed.
Supported Platforms: Debian/Ubuntu, FreeBSD: partially. Solaris/Illumos: untested.

It allows to seperately configure plugins, SSL certs and Remap Rules. Storage is configured globally.

This plugin assumes that you have current version of Apache Traffic Server in your packagemanager's repositories. See [fpm](https://github.com/jordansissel/fpm) for a project that allows you to easily create packages.

## Documentation

Installing Traffic Server:

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

## Release process

The version in Modulefile should be bumped according to [semver](http://semver.org/) *during development*, i.e.: The first commit after the release should already bump the version, as master at this point differs from the latest release.

When cutting a new release, please

* make sure that all tests pass
* make sure that the documentation is up-to-date
* verify that all dependencies are correct, and up-to-date
* create a new, *signed* tag and a package, using `make release`:

```
    igalic@levix ~/src/bw/puppet-trafficserver (git)-[master] % make release
    git tag -s 1.3.2 -m 't&r 1.3.2'
    ...
    git checkout 1.3.2
    Note: checking out '1.3.2'.
    ...
    HEAD is now at ff9aaae... bump version & explain how versioning should work
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
