class memcached(
  $package_ensure  = 'present',
  $logfile         = '/var/log/memcached.log',
  $max_memory      = false,
  $listen_ip       = '0.0.0.0',
  $tcp_port        = '11211',
  $udp_port        = '11211',
  $user            = '',
  $max_connections = '8192'
) {

  include memcached::params

  if $user == '' {
    $user_real = $memcached::params::user
  } else {
    $user_real = $user
  }

  package { $memcached::params::package_name:
    ensure => $package_ensure,
  }

  file { $memcached::params::config_file:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($memcached::params::config_tmpl),
    require => Package[$memcached::params::package_name],
  }

  service { $memcached::params::service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    subscribe  => File[$memcached::params::config_file],
  }
}
