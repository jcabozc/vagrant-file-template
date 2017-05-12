# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Iterate through entries in YAML file
  servers.each do |servers|
    sysver = servers["sysver"]
    saltver = servers["saltver"]
    salttype = servers["salttype"]
    saltmaster = servers["saltmaster"]
    minionid = servers["name"]
    server = servers["name"]
    ip = servers["ip"]
    hostname = servers["hostname"]
    config.vm.define servers["name"] do |srv|
      # if servers["salttype"] == "master" and
      #   srv.vm.synced_folder "./salt", "/srv/salt", owner: "root", group: "root"
      #   srv.vm.synced_folder "./pillar", "/srv/pillar", owner: "root", group: "root"
      # end
      config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
      srv.vm.box = servers["box"]
      srv.vm.network "private_network", ip: servers["ip"]
      srv.ssh.forward_x11 = true
      srv.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", servers["name"]]
        vb.customize ["modifyvm", :id, "--memory", servers["ram"]]
        vb.customize ["modifyvm", :id, "--cpus", servers["cpu"]]
      end
      srv.vm.provision :shell, :path => "aptconfig.sh"
      srv.vm.provision :shell, :path => "bootstrap.sh", :args => ["#{server}", "#{hostname}", "#{ip}"]
      srv.vm.provision :shell, :path => "salt_install.sh", :args => ["#{sysver}", "#{saltver}", "#{salttype}", "#{minionid}", "#{saltmaster}"]
    end
  end
end