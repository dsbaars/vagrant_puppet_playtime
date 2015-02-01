# Puppet labs APT key is added from hiera
class { 'apt':
	sources => $apt::sources}

class { '::python':
	pip        => true,
    dev        => true,
    virtualenv => true,
    gunicorn   => true,
}

# Foreman, Puppet Agent and puppetmaster:
class { '::puppet':
  	server => true,
  	server_reports        => 'puppetdb, store',
  	server_storeconfigs_backend => 'puppetdb',
	# server_httpd_service => 'nginx',
	# server_passenger => false
}

# Configure puppetdb and its underlying database
class { '::puppetdb':
  listen_address => '0.0.0.0',
  ssl_listen_address => '0.0.0.0'
}
# Configure the puppet master to use puppetdb
class { '::puppetdb::master::config':
  enable_reports => true,
  manage_report_processor => true
}

# class { '::apache':
# 	# package_ensure => absent,
# 	# service_ensure => absent
# }

# Puppetboard:
# Configure nginx on this server
class { 'nginx': }
# Configure Puppetboard

class { 'puppetboard':
  manage_git        => true,
  manage_virtualenv => false,
}

Package['python-pip'] -> Package <| provider == pip |>
Package['python-dev'] -> Package <| provider == pip |>

# class { 'puppetboard::apache::vhost':
#  vhost_name => 'puppetboard.localdomain',
#  port       => 80,
# }

class { 'puppetboard::nginx::vhost':
 vhost_name => 'puppetboard.localdomain',
 port       => 81,
}
