
datacat experiment
------------------

the [datacat](https://github.com/Brainsware/puppet-trafficserver/tree/datacat)
experiment was an explorative implementation that particularly showed its
limitations with testing. another limiting factor was the inflexibility of the
current API.


scope
-----

this experiment aims to break with those limits, by introducing a new API, that
of types. We *may* provide backwards compatibility wrappers in the form of the
existing types. However: the current module structure is not very well thought
through. we'll move away from its idiosyncratic style towards an established
community standard.

the resulting module can only support the kind of operating systems that ATS
itself supports.

Even though traffic server supports a multi-instance setup, this will only
support single-instance installations.

types
-----

* `traffic_line` is a command line tool to set and retrieve `records.config`
  settings

our module should provide a wrapper similar to how
[puppetlabs-postgresql](https://github.com/puppetlabs/puppetlabs-postgresql)'s
[postgresql_psql](https://github.com/puppetlabs/puppetlabs-postgresql/blob/master/lib/puppet/type/postgresql_psql.rb).
`traffic_line` is also used to reload the daemon after settings have been
changed.

* [`records.config`](https://docs.trafficserver.apache.org/en/latest/reference/configuration/records.config.en.html)
  is the main entry for configurations in Traffic Server.

our module should provide a wrapper similar to how puppetlabs-postgresql's
[postgresql_conf](https://github.com/puppetlabs/puppetlabs-postgresql/blob/master/lib/puppet/type/postgresql_conf.rb)

`records.config` can be prefetched. it would be nice if we could prefetch *all*
of it, using traffic_line, but that's currently not possible.

* [`remap.config`](https://docs.trafficserver.apache.org/en/latest/reference/configuration/remap.config.en.html)
  is the main entry for configuring "vhosts".

`remap.config` should be prefetched.

* [`ssl_multicert.config`](https://docs.trafficserver.apache.org/en/latest/reference/configuration/ssl_multicert.config.en.html)
  is the configuration file for configuring ssl vhosts (but not their
  mappings).

`ssl_multicert.config`, being implemented as provider, can check the paths of
the certificates paths. (this too can be prefetched.)

* [`storage.config`](https://docs.trafficserver.apache.org/en/latest/reference/configuration/storage.config.en.html)
  can configure directories or disks for storage

directories should be created and chowned to the Traffic Server user/group.
raw disks need per OS providers which can actually hook them into the udev,
devfs or whatever else is supported.

* [`plugin.config`](https://docs.trafficserver.apache.org/en/latest/reference/configuration/plugin.config.en.html)
  configures plugins

again, we can check for the paths in our provider.

n.b.: remap.config can potentially call this.

providers
---------

most of our providers can be implemented as simple file/line based.
remap.config is more complex and will need more consideration.

* for readability it would be nice if remap.config were to break up long lines
  into multiple lines.

* how do we handle plugins? Do we call them from this type? or do we rely on
  them being loaded elsewhere?

testing
--------

we'll follow puppetlabs's flagship modules such as testing patterns:

* minimalistic acceptance tests, covering most bases
* exhaustive unit (spec) tests, covering all combinations
