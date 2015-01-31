# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Requires:
# vagrant plugin install vagrant-cachier
# vagrant plugin install vagrant-puppet-install
# vagrant plugin install vagrant-hostmanager
# gem install librarian-puppet
Vagrant.configure("2") do |config|
  # host manager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  
  # cache plugin and ensure puppet is installed
  config.cache.auto_detect = true
  config.puppet_install.puppet_version = :latest
	
  # puppet + parallels boxes are rare.
	config.vm.box = "parallels/ubuntu-14.04"

  config.vm.hostname = 'puppetmaster.localdomain'
  config.vm.network :private_network, ip: '10.0.16.2'
  config.hostmanager.aliases = %w(puppetmaster.internal puppetboard.localdomain puppetmaster puppetmaster.localdomain)	

  config.vm.network "forwarded_port", guest: 8080, host: 8080 # puppetdb web interface
  config.vm.network "forwarded_port", guest: 8081, host: 8081 # puppetdb other port
  config.vm.network "forwarded_port", guest: 8082, host: 8082 # puppetdb repl

  config.vm.network "forwarded_port", guest: 8140, host: 8140 # foreman port

  config.vm.provider "parallels" do |prl|
    prl.optimize_power_consumption = true
    prl.memory = 4096
    prl.cpus =  2
  end

  config.vm.provision :puppet do |puppet|
    puppet.hiera_config_path = 'data/hiera.yaml'
  	puppet.working_directory = '/vagrant'
	  puppet.manifests_path = "manifests"
  	puppet.module_path = "modules"
  	puppet.manifest_file = "server.pp"
    puppet.options = [
     '--verbose',
     '--report',
     '--show_diff',
     '--pluginsync',
     '--summarize',
    #        '--evaltrace',
            '--debug',
    #        '--parser future',
    ]
  end
end
