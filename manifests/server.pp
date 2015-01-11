# Puppet labs APT key is added from hiera
class { 'apt':
	sources => $apt::sources}

# Foreman, Puppet Agent and puppetmaster:
class { '::puppet':
  server => true,
  server_storeconfigs_backend => true
}

# Configure puppetdb and its underlying database
class { 'puppetdb': }
# Configure the puppet master to use puppetdb
class { 'puppetdb::master::config': }

