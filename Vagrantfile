# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Requires:
# vagrant plugin install vagrant-cachier
# vagrant plugin install vagrant-puppet-install
# gem install librarian-puppet
Vagrant.configure("2") do |config|
  config.cache.auto_detect = true
  config.puppet_install.puppet_version = :latest
	
	config.vm.box = "parallels/ubuntu-14.04"
	
  config.vm.provision :puppet do |puppet|
    puppet.hiera_config_path = 'data/hiera.yaml'
  	puppet.working_directory = '/vagrant'
	  puppet.manifests_path = "manifests"
  	puppet.module_path = "modules"
  	puppet.manifest_file = "init.pp"
    puppet.options = [
     '--verbose',
     '--report',
     '--show_diff',
     '--pluginsync',
     '--summarize',
    #        '--evaltrace',
    #        '--debug',
    #        '--parser future',
    ]
  end
end
