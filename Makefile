sandbox_path=$(HOME)/contrail-5.0
repos_dir=$(HOME)/src/review.opencontrail.org/Juniper/
ansible_playbook=ansible-playbook -i inventory --extra-vars @vars.yaml --extra-vars @dev_config.yaml

.PHONY: presetup checkout_vnc setup build rpm containers deploy unittest sanity all

# this is the first bootstrap of the packages for the tool itself
# not a part of the "all" target, should be invoked manually
presetup:
	@test -e /root/contrail-5.0.0 || ln -s /root/contrail /root/contrail-5.0.0
	@pip list --format=legacy | grep 'urllib3' >/dev/null && pip uninstall -y urllib3 || true
	@pip list --format=legacy | grep 'setuptools' >/dev/null && pip uninstall -y setuptools || true
	@yum -q reinstall -y python-setuptools
	@yum -q install -y epel-release ansible vim docker rpm-build python-fixtures python-requests

# optional step, used when the sandbox is not mounted from host system
checkout_repos: presetup
	@scripts/checkout_repos.sh

# install all the primary build deps, docker engine etc.
setup: checkout_repos
	$(ansible_playbook) provisioning/setup_vm.yaml
	$(ansible_playbook) provisioning/complete_vm_config.yaml

build:
	echo "Not implemented yet"

rpm: setup
	@scripts/setup_build_logging.sh $(repos_dir)
	$(ansible_playbook) $(repos_dir)/contrail-project-config/playbooks/packaging/contrail-vnc-el.yaml
	createrepo $(HOME)/rpmbuild/RPMS/

containers:
	scripts/build-containers.sh

deploy_contrail_kolla: containers
	$(ansible_playbook) $(repos_dir)/contrail-project-config/playbooks/kolla/centos74-provision-kolla.yaml

deploy_contrail_k8s: containers
	$(ansible_playbook) $(repos_dir)/contrail-project-config/playbooks/docker/centos74-systest-kubernetes.yaml

unittests: build
	echo "Not implemented yet"

sanity: deploy
	echo "Not implemented yet"

all: containers

