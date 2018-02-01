# Contrail developer scripts

## Description

This repository contains scripts which allow to run Zuul's CI pipeline on 
developer's machine. Contrail contributors can use it to build and test their 
code locally. It can be used to debug problems found in 
[Zuulv3](http://zuulv3.opencontrail.org) CI system (eg. failing unit tests).

## How to use this repository

If you want to use Vagrant to run contrail build:
```
$ vagrant up
$ vagrant ssh
```

If you don't want to use vagrant, run `sudo make presetup` once on your 
virtual machine to prepare the environment for further tasks.

___

If you want to checkout the contrail code, run (on VM):
```
$ cd ~/contrail-dev-sandbox 
$ make checkout_vnc
```

___

To build RPMs run `make rpm` once on your virtual machine:
```
$ cd ~/contrail-dev-env
$ make rpm
```

___

If you want build containers run `make containers` target 
once it will prepare VM, after build RPM packages and containers:
```
$ cd ~/contrail-dev-env
$ make containers
```

___

To start full pipeline, run (on VM):
```
$ cd ~/contrail-dev-env
$ make all
```

See the Makefile for intermediate targets that can be executed if you don't 
want to run the full pipeline.

___

Artifacts from build targets (RPMs, containers) will be uploaded locally 
on virtual-machine. Local HTTP server and local registry run as containers 
locally on VM.  

After successful build packages are hosted on HTTP server accessible on 
host port, you can check it out with:
```
$ lynx http://172.17.0.1:6667/
```

Docker containers are hosted in local registry accessible on port 6666:
```
$ curl -s http://172.17.0.1:6666/v2/_catalog | python -m json.tool
```

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
