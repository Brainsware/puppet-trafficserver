# 2016-12-03 Releasing v1.0.4
# 2016-12-04 Releasing v1.0.5

Add support for Trafficserver 7.x. This version of Trafficserver removed the
`traffic_line` utility. So in this release of `brainsware-trafficserver`, we
add support for `traffic_ctl`.

# 2016-12-03 Releasing v1.0.4

This took longer than expected.

After polishing the types branch that has been sitting around for close to a
year, I've now added tests and updated the documentation.

We've caught up to Voxpupuli's modulesync and Travis Release process.
The latter was more painful than anticipated…

Unsurprisingly, for this module perhaps, this marks another release before a
breaking release: v2.0.0 will be dropping puppet 3.x support.

# 2015-10-20 Releasing v0.2.3

* Releasing current master, as-is, before we release our types branch as
  version 1.0.0
