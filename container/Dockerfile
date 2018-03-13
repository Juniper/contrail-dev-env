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
#ENV THIRD_PARTY_CACHE http://github.com/Juniper/contrail-third-party-cache/blob/master/analytics/centoslinux71

RUN mkdir -p $CONTRAIL
WORKDIR $CONTRAIL

RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo \
&&  chmod a+x /usr/bin/repo

COPY *.repo /etc/yum.repos.d

RUN yum -y install epel-release \
&&  yum -y update \
&&  yum -y install \
    docker \
    git \
    make \
    rpm-build \
    wget \
    yum-utils \
&&  yum clean all \
&&  rm -rf /var/cache/yum

RUN repo init --quiet -u https://github.com/Juniper/contrail-vnc \
&&  repo sync --quiet -j $(nproc) \
&&  make -f tools/packages/Makefile dep \
&&  python third_party/fetch_packages.py \
&&  yum clean all \
&&  rm -rf /var/cache/yum

RUN echo export CONTRAIL=$CONTRAIL >> $HOME/.bashrc \
&&  echo export LD_LIBRARY_PATH=$CONTRAIL/build/lib >> $HOME/.bashrc

ADD Dockerfile $HOME/

