If you want to use Vagrant:
* run "vagrant up" followed by "vagrant ssh"
* run "sudo -i", then "cd /home/vagrant/contrail-dev-sandbox"

run "make presetup" once to prepare the environment for further tasks

If you want to checkout the contrail code:
* run "make checkout_vnc"

run "make all" to start the full pipeline

See the Makefile for intermediate targets that can be executed if you don't want to 
run the full pipeline.

Configuration is made through the dev_config.yaml file, it is passed to most of the 
ansible playbooks as a variable file. The configuration options are documented
in comments.
