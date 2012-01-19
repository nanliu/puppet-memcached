class memcached::data {

  # Use osfamily if possible:
  case $::osfamily {
    'debian': {
      $memcached_package_name    = 'memcached'
      $memcached_service_name    = 'memcached'
      $memcached_config_path     = '/etc/memcached.conf'
      $memcached_config_template = "${module_name}/memcached.conf.erb"
      $memcached_user            = 'nobody'
      $memcached_logfile         = '/var/log/memcached.log'
    }
    'redhat': {
      $memcached_package_name    = 'memcached'
      $memcached_service_name    = 'memcached'
      $memcached_config_path     = '/etc/sysconfig/memcached'
      $memcached_config_template = "${module_name}/memcached_sysconfig.erb"
      $memcached_user            = 'memcached'
    }
    default: {
      warning "${module_name}: unsupported platform ${::operatingsystem}."
    }
  }

}
