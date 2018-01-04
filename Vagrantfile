# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

   config.vm.define :contrail_sandbox do |contrail_sandbox_config|
      contrail_sandbox_config.vm.box = "geerlingguy/centos7"
      contrail_sandbox_config.vm.hostname = "contrail-sandbox"
      contrail_sandbox_config.vm.network "private_network", ip: "192.168.60.200"
      contrail_sandbox_config.vm.synced_folder ".", "/home/vagrant/contrail-dev-sandbox"
      contrail_sandbox_config.vm.synced_folder "./code", "/home/vagrant/code"
      contrail_sandbox_config.ssh.forward_agent = true

      contrail_sandbox_config.vm.provider "virtualbox" do |vb|
         vb.memory = 8192
         vb.cpus = 4
      end
      #contrail_sandbox_config.vm.provision "ansible" do |ansible|
      #   ansible.playbook = "provisioning/site.yaml"
      #   ansible.verbose = "vvv"
      #end
   end
end
