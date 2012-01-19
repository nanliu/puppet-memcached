# Class: memcached
#
#   This module installs memcached
#
# Parameters:
#
#   * package_name: memacached package.
#   * package_version: installed (i.e. present), latest, or specific version.
#   * config_path: configuration file path.
#   * service_name: service name.
#
#   Configuration defaults obtained from memcached wiki:
#   http://code.google.com/p/memcached/wiki/NewConfiguringServer
#   * user: the account the service runs as.
#   * listen_ip: the address to bind the service (defeault: 0.0.0.0)
#   * tcp_port: tcp listening port. (default: 11211)
#   * udp_port: udp listening port. (default: 11211)
#   * max_connections: maximum concurrent connections. (default: 1024)
#   * max_memory: RAM used for item storage. If undefined use memory_ratio.
#   * memory_ratio: ratio * total_memory = max_memory. (default: 0.9)
#   * threads: number of worker threads. (default: 4)
#
# Actions:
#
#   Installs memcached, configures settings, and enable service.
#
# Requires:
#
#   hiera & hiera-puppet backend.
#
class memcached(
  $package_name    = hiera('memcached_package_name'),
  $package_ensure  = hiera('memcached_package_ensure', 'installed'),
  $config_path     = hiera('memcached_config_path'),
  $config_template = hiera('memcached_config_template'),
  $service_name    = hiera('memcached_service_name'),
  # Configuration file settings:
  $user            = hiera('memcached_user'),
  $listen_ip       = hiera('memcached_listen_ip', '0.0.0.0'),
  $tcp_port        = hiera('memcached_tcp_port', 11211),
  $udp_port        = hiera('memcached_udp_port', 11211),
  $max_connections = hiera('memcached_max_connections', 1024),
  $max_memory      = hiera('memcached_max_memory', undef),
  $memory_ratio    = hiera('memcached_memory_ratio', 0.9),
  $threads         = hiera('memcached_threads', 4),
  $logfile         = hiera('memcached_logfile', undef)
) {

  package { $package_name:
    ensure => $package_ensure,
  }

  file { 'memcached.conf':
    path    => $config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($config_template),
    require => Package[$package_name],
  }

  service { $service_name:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    subscribe  => File['memcached.conf'],
  }

}
