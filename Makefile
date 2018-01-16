sandbox_path=$(HOME)/contrail-5.0
ansible_playbook=ansible-playbook -i inventory --extra-vars @vars.yaml --extra-vars @dev_config.yaml

.PHONY: presetup checkout_vnc setup build rpm containers deploy unittest sanity all

# this is the first bootstrap of the packages for the tool itself
# not a part of the "all" target, should be invoked manually
presetup:
	yum install -y epel-release ansible vim

# optional step, used when the sandbox is not mounted from host system
checkout_vnc: setup
	scripts/checkout_vnc.sh $(sandbox_path)

# install all the primary build deps, docker engine etc.
setup:
	ansible-playbook -i inventory --extra-vars @dev_config.yaml provisioning/setup1.yaml
	ansible-playbook -e '{"CREATE_CONTAINERS":false, "CONTAINER_VM_CONFIG": {"network": {"ntpserver":"127.0.0.1"}}, "CONTAINER_REGISTRY": "", "CONFIGURE_VMS":true, "roles": {"localhost":[]}}' -i inventory -c local  code/contrail-ansible-deployer/playbooks/deploy.yml
	ansible-playbook -i inventory --extra-vars @dev_config.yaml provisioning/setup2.yaml

build:
	echo "Not implemented yet"

rpm: setup
	$(ansible_playbook) code/contrail-project-config/playbooks/packaging/contrail-vnc-el.yaml

containers: rpm
	echo "Not implemented yet"

deploy: containers
	$(ansible_playbook) code/contrail-project-config/playbooks/kolla/centos74-provision-kolla.yaml

# temp target without dependencies for independent testing
deploy2:
	$(ansible_playbook) code/contrail-project-config/playbooks/kolla/centos74-provision-kolla.yaml

unittests: build
	echo "Not implemented yet"

sanity: deploy
	echo "Not implemented yet"

all: sanity
