# Puppet labs APT key is added from hiera
class { 'apt':
	sources => $apt::sources}

# Foreman, Puppet Agent and puppetmaster:
class { '::puppet':
  server                      => true,
  server_reports              => 'puppetdb, store',
  server_storeconfigs_backend => 'puppetdb',
  runinterval                 => 120,
  # disable foreman
  server_external_nodes       => '',
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

file { "${::puppet::server_dir}/autosign.conf":
  mode    => 664,
  owner   => 'puppet',
  group   => 'puppet',
  content => "*.internal
*.localdomain
*
"
}


# Puppetboard:
# Configure Apache on this server
class { '::apache::mod::wsgi': }
# Configure Puppetboard

class { '::puppetboard':
  manage_git        => true,
  manage_virtualenv => true,
}

class { '::puppetboard::apache::vhost':
 vhost_name => 'puppetboard.localdomain',
 port       => 80,
}
