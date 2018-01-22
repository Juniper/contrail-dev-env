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

To start full pipeline, run (on VM):
```
$ cd ~/contrail-dev-sandbox
$ make all
```

___

See the Makefile for intermediate targets that can be executed if you don't 
want to run the full pipeline.

Configuration is made through the dev_config.yaml file, it is passed to most 
of the ansible playbooks as a variable file. The configuration options are 
documented in comments.
