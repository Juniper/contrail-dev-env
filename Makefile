repos_dir=$(HOME)/src/review.opencontrail.org/Juniper/
container_builder_dir=$(repos_dir)contrail-container-builder
ansible_playbook=ansible-playbook -i inventory --extra-vars @vars.yaml --extra-vars @dev_config.yaml

# include RPM-building targets
-include $(HOME)/contrail/tools/packages/Makefile

list-containers: prepare-containers
	@$(container_builder_dir)/containers/build.sh list | grep -v INFO | sed 's,/,_,g'

fetch_packages:
	@cd $(HOME)/contrail/third_party && python -u fetch_packages.py 2>&1 | grep -Ei 'Processing|patching'

setup: fetch_packages
	@test -e /root/contrail-5.0.0 || ln -s /root/contrail /root/contrail-5.0.0
	@pip list | grep urllib3 >/dev/null && pip uninstall -y urllib3 || true
	@pip -q uninstall -y setuptools || true
	@yum -q reinstall -y python-setuptools
	@scripts/checkout_repos.sh

container-%: prepare-containers createrepo
	@$(container_builder_dir)/containers/build.sh $(patsubst container-%,%,$(subst _,/,$(@)))

containers: create-repo prepare-containers
	@$(container_builder_dir)/containers/build.sh

deploy_contrail_kolla: containers
	@$(ansible_playbook) $(repos_dir)/contrail-project-config/playbooks/kolla/centos74-provision-kolla.yaml

deploy_contrail_k8s: containers
	@$(ansible_playbook) $(repos_dir)/contrail-project-config/playbooks/docker/centos74-systest-kubernetes.yaml

unittests ut: build
	@echo "$@: not implemented"

sanity: deploy
	@echo "$@: not implemented"

build deploy:
	@echo "$@: not implemented"

# utility targets
sync:
	@cd $(HOME)/contrail && repo sync -q --no-clone-bundle -j $(shell nproc)

setup:
	@test -e /root/contrail-5.0.0 || ln -s /root/contrail /root/contrail-5.0.0
	@pip list | grep urllib3 >/dev/null && pip uninstall -y urllib3 || true
	@pip -q uninstall -y setuptools || true
	@yum -q reinstall -y python-setuptools
	@scripts/checkout_repos.sh

$(repos_dir)contrail-container-builder/.git:
	@scripts/prepare-containers.sh

prepare-containers: $(container_builder_dir)/.git

create-repo:
	@mkdir -p $(HOME)/contrail/RPMS
	@createrepo -C $(HOME)/contrail/RPMS/

# Clean targets
clean-containers:
	@test -d $(container_builder_dir) && rm -rf $(repos_dir)contrail-container-builder || true

clean-repo:
	@test -d $(HOME)/contrail/RPMS/repodata && rm -rf $(HOME)/contrail/RPMS/repodata || true

clean-rpm:
	@test -d $(HOME)/contrail/RPMS && rm -rf $(HOME)/contrail/RPMS/* || true

clean: clean-containers clean-repo clean-rpm
	:

all: dep rpm containers

.PHONY: setup build containers createrepo unittests ut sanity all

