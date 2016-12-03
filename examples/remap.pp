class { '::trafficserver':
  user  => 'igalic',
  group => 'igalic',
}

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

