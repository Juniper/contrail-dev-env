# contrail-dev-env: Contrail Developer Environment

## Problems? Need Help?

This repository is actively maintained via [Gerrit] so please let us know about
any problems you find. You can ask for help on [Slack] but if no one replies
right away, go ahead and open a bug on [Launchpad] and tag the bug with the
tag "dev-env" and it will get looked at soon. You can also post to the new
[Google Group] if you're having trouble but don't know if the problem is a bug
or a mistake on your part.

## Documentation for dev-env components

Since dev-env uses generally available contrail components, please refer to following documentation pages:

1. for packages generation: [contrail-packages](https://github.com/Juniper/contrail-packages/blob/master/README.md)
2. for building containers: [contrail-container-builder](https://github.com/Juniper/contrail-container-builder/blob/master/README.md)
3. for deployments: [contrail-ansible-deployer](https://github.com/Juniper/contrail-ansible-deployer/blob/master/README.md)

## Container-based (standard)

### 1. Install docker
```
For mac:          https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac
```
For CentOS/RHEL/Fedora linux host:
```
yum install docker
```
For Ubuntu linux host:
```
apt install docker.io
```

NOTE (only if you hit any issues):
Make sure that your docker engine supports images bigger than 10GB. For instructions,
see here: https://stackoverflow.com/questions/37100065/resize-disk-usage-of-a-docker-container
Make sure that there is TCP connectivity allowed between the containers in the default docker bridge network,
(for example disable firewall).

### 2. Clone dev setup repo
```
git clone https://github.com/Juniper/contrail-dev-env
cd contrail-dev-env
```

### 3. Execute script to start 3 containers
```
sudo ./startup.sh
```

##### docker ps -a should show these 3 containers #####
```
contrail-developer-sandbox [For running scons, unit-tests etc]
contrail-dev-env-rpm-repo  [Repo server for contrail RPMs after they are build]
contrail-dev-env-registry  [Registry for contrail containers after they are built]
```

### 4. Attach to developer-sandbox container

```
docker attach contrail-developer-sandbox
```

### 5. Run scons, UT, make RPMS or make containers

*Required* first steps in the container:

```
cd /root/contrail-dev-env
make sync           # get latest code using repo tool
make fetch_packages # pull third_party dependencies
make setup          # set up docker container
make dep            # install dependencies
```

*Optional*: if you want to work on other version of code, e.g. `R5.0`, start with following steps
*before* the "Required" part:

```
cd /root/contrail
git config --global user.name "Your Name"
git config --global user.email "your@e-mail.com"
repo init -b R5.0
```

Now you can run any commands using the source code sandbox, e.g.

```
cd /root/contrail
scons # ( or "scons test" etc)
```

Or use any of additional `make` targets provided by `contrail-dev-env/Makefile`:

* `make setup` - initial configuration of image (required to run once)
* `make sync` - sync code in `contrail` directory using `repo` tool
* `make fetch_packages` - pull third_party dependencies (after code checkout)
* `make dep` - installs all build dependencies
* `make dep-<pkg_name>` - installs build dependencies for <pkg_name>
* `make list` - lists all available rpm targets
* `make rpm` - builds all RPMs
* `make rpm-<pkg_name>` - builds single RPM for <pkg_name>
* `make list-containers` - lists all container targets
* `make containers` - builds all containers, requires RPM packages in /root/contrail/RPMS
* `make container-<container_name>` - builds single container as a target, with all docker dependencies
* `make clean{-containers,-repo,-rpm}` - artifacts cleanup

### 6. Testing the deployment

See https://github.com/Juniper/contrail-ansible-deployer/wiki/Contrail-with-Kolla-Ocata .
Set `CONTAINER_REGISTRY` to `registry:5000` to use containers built in step 5.

## Bring-your-own-VM (experimental)

*Note:* only RedHat 7 and CentOS 7 are supported at this time!

1. Clone this repository to a directory on a VM.
2. Run `vm-dev-env/init.sh` (you might be asked for your password as some steps require the use of sudo).
  a. You can also run `vm-dev-env/init.sh -n` if you don't want to clone work directory on a VM. Then you have to mount sandbox to directory named `contrail` next to `contrail-dev-env`.
3. Run `make fetch_packages` to pull dependencies to `contrail/third_party`
4. Run `sudo ./startup.sh -b` to start required containers.
4. You can use the Makefile targets described above to build contrail.

[Gerrit]: https://review.opencontrail.org/#/admin/projects/Juniper/contrail-dev-env
[Slack]: https://tungstenfabric.slack.com/messages/C0DQ23SJF/
[Launchpad]: https://bugs.launchpad.net/opencontrail/+filebug
[Google Group]: https://groups.google.com/forum/#!forum/tungsten-dev
