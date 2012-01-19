class memcached::data {
  $memcached_package = {}
  $memcached_config  = {}
  $memcached_service = {}
  $memcached_setting = {}

  $memcached_package['ensure']          = present
  $memcached_setting['logfile']         = '/var/log/memcached.log'
  $memcached_setting['max_memory']      = false
  $memcached_setting['listen_ip']       = '0.0.0.0'
  $memcached_setting['tcp_port']        = '11211'
  $memcached_setting['udp_port']        = '11211'
  $memcached_setting['max_connections'] = '8192'

  # Use osfamily if possible:
  if ($::osfamily == 'Debian') or ($::operatingsystem =~ /(?i:ubuntu|debian)/) {
    $memcached_package['name']    = 'memcached'
    $memcached_service['name']    = 'memcached'
    $memcached_config['path']     = '/etc/memcached.conf'
    $memcached_config['template'] = "${module_name}/memcached.conf.erb"
    $memcached_user               = 'nobody'
  } elsif ($::osfamily == 'Redhat') or ($::operatingsystem =~ /(?i:redhat|centos)/) {
    $memcached_package['name']    = 'memcached'
    $memcached_service['name']    = 'memcached'
    $memcached_config['path']     = '/etc/sysconfig/memcached'
    $memcached_config['template'] = "${module_name}/memcached_sysconfig.erb"
    $memcached_user               = 'memcached'
  } else {
    fail("Unsupported platform: ${::operatingsystem}")
  }
}
