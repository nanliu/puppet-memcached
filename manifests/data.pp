class memcached::data {
  $package = {}
  $config  = {}
  $service = {}
  $setting = {}

  $package['ensure']          = present
  $setting['logfile']         = '/var/log/memcached.log'
  $setting['max_memory']      = false
  $setting['listen_ip']       = '0.0.0.0'
  $setting['tcp_port']        = '11211'
  $setting['udp_port']        = '11211'
  $setting['max_connections'] = '8192'

  # Use osfamily if possible:
  if ($::osfamily == 'Debian') or ($::operatingsystem =~ /(?i:ubuntu|debian)/) {
    $package['name']    = 'memcached'
    $service['name']    = 'memcached'
    $config['path']     = '/etc/memcached.conf'
    $config['template'] = "${module_name}/memcached.conf.erb"
    $user               = 'nobody'
  } elsif ($::osfamily == 'Redhat') or ($::operatingsystem =~ /(?i:redhat|centos)/) {
    $package['name']    = 'memcached'
    $service['name']    = 'memcached'
    $config['path']     = '/etc/sysconfig/memcached'
    $config['template'] = "${module_name}/memcached_sysconfig.erb"
    $user               = 'memcached'
  } else {
    fail("Unsupported platform: ${::operatingsystem}")
  }
}
