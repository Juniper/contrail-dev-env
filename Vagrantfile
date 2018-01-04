# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

   config.vm.define :contrail_sandbox do |contrail_sandbox_config|
      contrail_sandbox_config.vm.box = "centos/7"
      contrail_sandbox_config.vm.hostname = "contrail-sandbox"
      contrail_sandbox_config.vm.network "private_network", ip: "192.168.60.200"
      contrail_sandbox_config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
      contrail_sandbox_config.vm.synced_folder "./code", "/home/vagrant/code", :type => "nfs"
      contrail_sandbox_config.ssh.forward_agent = true
      #contrail_sandbox_config.ssh.insert_key = true 
      #contrail_sandbox_config.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key" ]
      #contrail_sandbox_config.ssh.username = "ubuntu"
      #contrail_sandbox_config.ssh.password = "ubuntu"

      contrail_sandbox_config.vm.provider "virtualbox" do |vb|
         vb.memory = 8192
         vb.vcpus = 4
      end
      contrail_sandbox_config.vm.provision "ansible" do |ansible|
         ansible.playbook = "provisioning/site.yaml"
      end
   end
end
