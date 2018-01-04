sandbox_path=/root/contrail-5.0

# this is the first bootstrap of the packages for the tool itself
# not a part of the "all" target, should be invoked manually
presetup:
	yum install -y epel-release ansible vim

# optional step, used when the sandbox is not mounted from host system
checkout_vnc: setup
	scripts/checkout_vnc.sh $(sandbox_path)

# install all the primary build deps, docker engine etc.
setup:
	ansible-playbook -i inventory provisioning/site.yaml

build:
	echo "Not implemented yet"

rpm:
	ansible-playbook -i inventory --extra-vars @vars.yaml --extra-vars @dev_config.yaml code/contrail-project-config/playbooks/packaging/contrail-vnc-el.yaml

containers:
	echo "Not implemented yet"

deploy:
	echo "Not implemented yet"

unittests:
	echo "Not implemented yet"

sanity:
	echo "Not implemented yet"

all: setup build rpm containers deploy 
