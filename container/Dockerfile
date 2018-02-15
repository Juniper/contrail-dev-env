# docker build --tag opencontrail/developer-sandbox:centos-7.4 .
# gpasswd -a $USER docker
# newgrp docker
# 
# docker run command to pick time from host 
# docker run -it -v /etc/localtime:/etc/localtime opencontrail/developer-sandbox:centos-7.4
# 
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
RUN yum -y install java-1.7.0-openjdk protobuf protobuf-compiler protobuf-devel libevent-devel tokyocabinet-devel librdkafka-devel cyrus-sasl-devel cyrus-sasl cyrus-sasl-lib lz4-devel

# contrail-kubernetes and contrail-config
RUN pip install tox geventhttpclient setuptools requests

RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo>/usr/bin/repo
RUN chmod a+x /usr/bin/repo

RUN mkdir -p $RPMS
WORKDIR $RPMS
RUN wget -q "https://downloads.datastax.com/cpp-driver/centos/7/cassandra/v2.7.0/cassandra-cpp-driver-devel-2.7.0-1.el7.centos.x86_64.rpm" "https://downloads.datastax.com/cpp-driver/centos/7/cassandra/v2.7.0/cassandra-cpp-driver-2.7.0-1.el7.centos.x86_64.rpm" "http://mirror.centos.org/centos/6/os/x86_64/Packages/lucene-contrib-2.3.1-5.9.el6.noarch.rpm" "http://mirror.centos.org/centos/6/os/x86_64/Packages/lucene-2.3.1-5.9.el6.noarch.rpm" "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/noarch/RPMS.classic/swing-layout-1.0.4-alt2_13jpp8.noarch.rpm" "http://10.84.5.120/cs-shared/builder/cache/centoslinux71/mitaka/snapshot-03092017/grok/grok-1.20110308.1-0contrail0.x86_64.rpm" "http://10.84.5.120/cs-shared/builder/cache/centoslinux71/mitaka/snapshot-03092017/grok/grok-devel-1.20110308.1-0contrail0.x86_64.rpm" "http://10.84.5.120/cs-shared/builder/cache/centoslinux71/juno/libipfix-110209-1.el7.centos.x86_64.rpm" "http://10.84.5.120/cs-shared/builder/cache/centoslinux71/mitaka/snapshot-06202016/contrail-thirdparty/libzookeeper-3.4.8-0contrail0.el7.centos.x86_64.rpm" "http://10.84.5.120/cs-shared/builder/cache/centoslinux71/mitaka/snapshot-06202016/contrail-thirdparty/libzookeeper-devel-3.4.8-0.contrail0.el7.centos.x86_64.rpm" "http://10.84.5.120/cs-shared/builder/cache/centoslinux71/mitaka/snapshot-06202016/contrail-thirdparty/zookeeper-3.4.8-0.contrail1.el7.centos.x86_64.rpm" 
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
