# contrail-dev-env: Contrail Developer Environment

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
* `make container-<container_name>` - builds single container as a taret, with all docker dependencies
* `make clean{-containers,-repo,-rpm}` - artifacts cleanup

### 6. Testing the deployment

See https://github.com/Juniper/contrail-ansible-deployer/wiki/Contrail-with-Kolla-Ocata .
Set `CONTAINER_REGISTRY` to `registry:5000` to use containers built in step 5.

## Bring-your-own-VM (experimental)

*Note:* only RedHat 7 and CentOS 7 are supported at this time!

1. clone this repository to a directory on a VM
2. run `vm-dev-env/init.sh` (you might be asked for your password as some steps require the use of sudo)
3. you can use the same Makefile targets as in the container
