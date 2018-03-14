repos_dir=$(HOME)/src/review.opencontrail.org/Juniper/
ansible_playbook=ansible-playbook -i inventory --extra-vars @vars.yaml --extra-vars @dev_config.yaml

-include $(HOME)/contrail/tools/packages/Makefile

.PHONY: presetup checkout_vnc setup build rpm containers deploy unittest sanity all

setup:
	@test -e /root/contrail-5.0.0 || ln -s /root/contrail /root/contrail-5.0.0
	@pip list | grep urllib3 >/dev/null && pip uninstall -y urllib3 || true
	@pip -q uninstall -y setuptools || true
	@yum -q reinstall -y python-setuptools
	@scripts/checkout_repos.sh

build:
	echo "Not implemented yet"

createrepo:
	@mkdir -p $(HOME)/contrail/RPMS
	createrepo $(HOME)/contrail/RPMS/

containers: createrepo
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

