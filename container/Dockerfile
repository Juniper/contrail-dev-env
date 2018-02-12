# docker build --tag opencontrail/developer-sandbox:centos-7.4 .
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

# contrail-control
RUN yum -y install git python-lxml autoconf libtool unzip wget flex bison libxml2-devel openssl-devel cmake libcurl-devel tcpdump bzip2 patch gcc-c++ boost-devel tbb-devel make vim-common python-virtualenv python-pip scons gmock gtest libuv libuv-devel vim ruby gdb python-sphinx.noarch

# contrail-analytics
RUN yum -y install java-1.7.0-openjdk protobuf protobuf-compiler protobuf-devel libevent-devel tokyocabinet-devel librdkafka-devel 

# contrail-kubernetes
RUN pip install tox

RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo>/usr/bin/repo
RUN chmod a+x /usr/bin/repo

RUN mkdir -p $RPMS
WORKDIR $RPMS
RUN wget -q "http://downloads.datastax.com/cpp-driver/centos/7/cassandra/v2.2.0/cassandra-cpp-driver-2.2.0-1.el7.centos.x86_64.rpm"
RUN wget -q "http://downloads.datastax.com/cpp-driver/centos/7/cassandra/v2.2.0/cassandra-cpp-driver-devel-2.2.0-1.el7.centos.x86_64.rpm"
RUN wget -q "http://mirror.centos.org/centos/6/os/x86_64/Packages/lucene-contrib-2.3.1-5.9.el6.noarch.rpm"
RUN wget -q "http://mirror.centos.org/centos/6/os/x86_64/Packages/lucene-2.3.1-5.9.el6.noarch.rpm"
RUN wget -q "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/noarch/RPMS.classic/swing-layout-1.0.4-alt2_13jpp8.noarch.rpm"
RUN wget -q "http://dl.fedoraproject.org/pub/epel/6/i386/Packages/o/opengrok-0.9-1.el6.noarch.rpm"
RUN wget -q "http://vuksan.com/centos/RPMS/x86_64/grok-devel-1.20101030.3088-2.x86_64.rpm"

RUN wget -q "https://builds.midonet.org/misc/testing/el7/x86_64/zookeeper-3.4.8-1.el7.x86_64.rpm"
RUN wget -q "https://builds.midonet.org/misc/testing/el7/x86_64/libzookeeper-devel-3.4.8-1.el7.x86_64.rpm"
RUN wget -q "https://builds.midonet.org/misc/testing/el7/x86_64/libzookeeper-3.4.8-1.el7.x86_64.rpm"
RUN wget -q "https://github.com/rombie/contrail-third-party/blob/libipfix/libipfix-110209-1.el6.x86_64.rpm?raw=true"
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
