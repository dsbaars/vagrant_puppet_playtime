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

  # Run the hostmanager
  config.vm.provision :hostmanager
    
  config.vm.provider "parallels" do |prl|
    prl.optimize_power_consumption = true
    prl.memory = 4096
    prl.cpus =  2
  end

  # Create master node
  config.vm.define "master" do |master|
    master.vm.hostname = 'puppetmaster.localdomain'
    master.vm.network :private_network, ip: '10.0.16.2'
    master.hostmanager.aliases = %w(puppetmaster.internal puppetboard.localdomain puppetmaster puppetmaster.localdomain)	

    master.vm.network "forwarded_port", guest: 8080, host: 8080 # puppetdb web interface
    master.vm.network "forwarded_port", guest: 8081, host: 8081 # puppetdb other port
    master.vm.network "forwarded_port", guest: 8082, host: 8082 # puppetdb repl

    master.vm.network "forwarded_port", guest: 8140, host: 8140 # foreman port

    master.vm.synced_folder "puppet_dir/manifests",     "/etc/puppet/manifests"
    master.vm.synced_folder "puppet_dir/modules",       "/etc/puppet/modules"
    master.vm.synced_folder "puppet_dir/environments",  "/etc/puppet/environments"
    master.vm.synced_folder "puppet_dir/templates",     "/etc/puppet/templates"

    master.vm.provision :puppet do |puppet|
      puppet.hiera_config_path = 'master/data/hiera.yaml'
      puppet.working_directory = '/vagrant/master'
      puppet.manifests_path = "master/manifests"
      puppet.module_path = "master/modules"
      puppet.manifest_file = "server.pp"
      puppet.options = [
       # '--verbose',
       '--report',
       '--show_diff',
       '--pluginsync',
       '--summarize',
      #'--evaltrace',
      #'--debug',
      #'--parser future',
      ]
    end
  end

  config.vm.define "client" do |client|
    client.vm.hostname = 'puppetclient.localdomain'
    client.vm.network :private_network, ip: '10.0.16.3'
    client.hostmanager.aliases = %w{puppetclient.internal}

    client.vm.provision "puppet_server" do |puppet|
      puppet.puppet_server = 'puppetmaster.localdomain'
      puppet.options = [
       #'--verbose',
       '--report',
       '--show_diff',
       '--pluginsync',
       '--summarize',
       '--waitforcert', 120,
       #'--debug',
      ]
    end
  end
end
