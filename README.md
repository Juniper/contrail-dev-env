# Contrail developer scripts

## Description

This repository contains scripts which allow to run Zuul's CI pipeline on 
developer's machine. Contrail contributors can use it to build and test their 
code locally. It can be used to debug problems found in 
[Zuulv3](http://zuulv3.opencontrail.org) CI system (eg. failing unit tests).

 
### 1. Setup build VM
With vagrant or your own VM

#### 1.1 With vagrant
If you want to use Vagrant to build Contrail clone this repository on your dev machine and run:

```
$ vagrant up
$ vagrant ssh
```

#### 1.2 Bring your own Centos VM
```
Login to your Centos VM
git clone https://github.com/Juniper/contrail-dev-env.git
cd contrail-dev-env
make presetup
```

### 2. Checkout source code

To checkout Contrail source code, on dev VM run following target:

```
$ cd ~/contrail-dev-env	
$ make checkout_vnc
```

This will checkout current `master` branch and will put it in HOME directory. Path for 
source checkout can be modified in Makefile using `sandbox_path` variable. To see what
steps are executed during checkout phase check `checkout_vnc.sh` script under 
`contrail-dev-env/scripts/`. 

If you want to build packages and containers with your code patches you have to apply those
by yourself on top of Contrail repo sandbox.  

### 3. Build RPM packages

This step requires `make checkout_vnc` to be run first or manually setup sandbox directory 
with Contrail code.  

To build RPMs run `make rpm` on your virtual machine:

```
$ cd ~/contrail-dev-env
$ make rpm
```

Logs for build process will be available during and after execution of build tasks 
in `$HOME/contrail-build-logs/contrail-logs`. Each build task has separate log file.

After successful build RPM artifacts will be hosted on HTTP server inside 
container run on dev VM. Those can be accessed using following URL:

```
$ lynx http://172.17.0.1:6667/
```

### 4. Build containers

If you want to build containers run `make containers` target. This target will run intermediate 
targets to: prepare VM, build RPM packages and finally  build containers. You can run with:

```
$ cd ~/contrail-dev-env
$ make containers
```

In current version docker build logs will be deleted after successful run of build proccess. 
In case of failure build logs can be access in `$HOME/contrail-container-builder/containers`.

After successfull build containers will be uploaded to private registry run on
dev VM. Containers can be accessed on following registry:

```
$ curl -s http://172.17.0.1:6666/v2/_catalog | python -m json.tool
```

### 5. Full CI pipeline

To start full pipeline on dev VM run:

```
$ cd ~/contrail-dev-env
$ make all
```

See previous section in this instruction or the Makefile for intermediate targets that can be 
executed if you don't want to run the full pipeline.

___

Configuration is made through the `dev_config.yaml` file, it is passed to most 
of the ansible playbooks as a variable file. The configuration options are 
documented in comments.

## Known issues

### Non-vagrant deployment

* docker selinux deployment error
You can get it conflicted with `container-selinux.noarch` package if it's installed in your CentOS. Remove it with yum.

* sudo root password
If you're not root you'll have to add `ansible_become_pass: mypass` into `dev_config.yaml` file

## TODO

* increase visibility of building proccess by streaming logs using Ansible custom shell module
