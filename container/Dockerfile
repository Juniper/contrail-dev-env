 docker build --tag opencontrail/developer-sandbox:centos-7.4 .
# gpasswd -a $USER docker
# newgrp docker
FROM centos:7.4.1708

ENV USER root
ENV HOME /root/
ENV CONTRAIL $HOME/contrail
ENV RPMS $HOME/rpms

USER root

RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install git python-lxml autoconf libtool unzip wget flex bison libxml2-devel openssl-devel cmake libcurl-devel tcpdump bzip2 patch gcc-c++ boost-devel tbb-devel make vim-common python-virtualenv python-pip scons gmock gtest libuv libuv-devel vim ruby
RUN pip install tox
RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo>/usr/bin/repo
RUN chmod a+x /usr/bin/repo

RUN mkdir -p $RPMS
WORKDIR $RPMS
RUN wget -q http://downloads.datastax.com/cpp-driver/centos/7/cassandra/v2.2.0/cassandra-cpp-driver-2.2.0-1.el7.centos.x86_64.rpm
RUN wget -q http://downloads.datastax.com/cpp-driver/centos/7/cassandra/v2.2.0/cassandra-cpp-driver-devel-2.2.0-1.el7.centos.x86_64.rpm
RUN yum -y install $RPMS/*rpm

RUN mkdir -p $CONTRAIL
WORKDIR $CONTRAIL
RUN repo init --quiet -u https://github.com/Juniper/contrail-vnc
RUN repo sync
RUN python third_party/fetch_packages.py
RUN echo export CONTRAIL=$CONTRAIL >> $HOME/.bashrc
RUN echo export LD_LIBRARY_PATH=$CONTRAIL/build/lib >> $HOME/.bashrc
ADD Dockerfile $HOME/

# RUN NO_HEAPCHECK=TRUE BUILD_ONLY=TRUE scons --optimization=debug -uj32 controller/src/bgp:test controller/src/xmpp:test control-node contrail-vrouter-agent control-node
# RUN LD_LIBRARY_PATH=$CONTRAIL/build/lib NO_HEAPCHECK=TRUE LOG_DISABLE=TRUE scons -i --optimization=debug -uj32 controller/src/bgp:test controller/src/xmpp:test
