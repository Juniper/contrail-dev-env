### 1. Install docker
```
For mac:          https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac
```
```
For linux host:   yum install docker/apt install docker.io
```

NOTE (only if you hit any issues): 
Make sure that your docker engine supports images bigger than 10GB. For instructions,
see here: https://stackoverflow.com/questions/37100065/resize-disk-usage-of-a-docker-container
Make sure, that there is TCP connectivity allowed between the containers in the default docker bridge network,
so, for example disable firewall.

### 2. Clone dev setup repo
```
git clone https://github.com/Juniper/contrail-dev-env
cd contrail-dev-env
```

### 3. Execute script to start 3 containers
```
./startup.sh
```

##### docker ps -a should show these 3 containers #####
```
* contrail-developer sandbox [For running scons, unit-tests etc]
* httpd container            [Repo server for contrail RPMs after they are build]
* registry container         [Registry for contrail containers after they are built]
```

### 4. Attach to developer-sandbox container

```
docker attach contrail-developer-sandbox
```

### 5. Run scons, UT, make RPMS or make containers

*Required* first steps in the container:

```
cd /root/contrail-dev-env
make setup
cd /root/contrail
repo sync # to get the latest code checked out
cd /root/contrail-dev-env
make dep
```

Now you can run any commands using the source code sandbox, e.g.

```
cd /root/contrail
scons # ( or "scons test" etc)
```

Additional `make` targets provided by `contrail-dev-env/Makefile`:

* `make dep` - installs all build dependencies
* `make dep-<pkg_name>` - installs build dependencies for <pkg_name>
* `make rpm` - builds all RPMs
* `make rpm-<pkg_name>` - builds single RPM for <pkg_name>
* `make containers` - builds all containers, requires RPM packages in /root/contrail/RPMS

### 6. Testing the deployment

See https://github.com/Juniper/contrail-ansible-deployer/wiki/Contrail-with-Kolla-Ocata .
Set `CONTAINER_REGISTRY` to `registry:5000` to use containers built in step 5.
