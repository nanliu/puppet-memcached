class memcached(
  $package = hiera_hash('memcached_package'),
  $config  = hiera_hash('memcached_config'),
  $service = hiera_hash('memcached_service'),
  $setting = hiera_hash('memcached_setting')
) {

  package { $package['name']:
    ensure => $package['ensure'],
  }

  file { $config['path']:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($config['template']),
    require => Package[$package['name']],
  }

  service { $service['name']:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    subscribe  => File[$config['file']],
  }
}
