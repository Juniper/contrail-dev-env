# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
DEV_ENV_DIR="/root/contrail-dev-env"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

   config.vm.define :contrail_sandbox do |contrail_sandbox_config|
      contrail_sandbox_config.vm.box = "geerlingguy/centos7"
      contrail_sandbox_config.vm.hostname = "contrail-sandbox"
      contrail_sandbox_config.vm.network "private_network", ip: "192.168.60.200"
      contrail_sandbox_config.vm.synced_folder ".", DEV_ENV_DIR
      contrail_sandbox_config.ssh.forward_agent = true
      contrail_sandbox_config.ssh.insert_key = 'true'
      contrail_sandbox_config.ssh.username = 'root'
      contrail_sandbox_config.ssh.password = 'vagrant'

      contrail_sandbox_config.vm.provider "virtualbox" do |vb|
         vb.memory = 8192
         vb.cpus = 4
      end
      contrail_sandbox_config.vm.provision "shell", name: "run presetup" do |presetup|
        presetup.inline = "make -f $1/Makefile presetup"
        presetup.args = DEV_ENV_DIR
      end
   end
end
