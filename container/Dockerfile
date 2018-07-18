FROM centos:7.4.1708

ENV USER root
ENV HOME /root/
ENV CONTRAIL $HOME/contrail

RUN mkdir -p $CONTRAIL
WORKDIR $CONTRAIL

# Install android repo
RUN curl -s https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo \
&&  chmod a+x /usr/bin/repo

# Remove Centos default repo in order to freeze version 7.4.1708
RUN rm -f /etc/yum.repos.d/*.repo

# Inject repositories that we might need
COPY *.repo /etc/yum.repos.d

# Install basic packages
RUN yum -y install epel-release \
&&  yum -y update \
&&  yum -y install \
    createrepo \
    docker \
    docker-python \
    gcc \
    gdb \
    git \
    kernel \
    make \
    python-devel \
    python-pip \
    rpm-build \
    vim \
    wget \
    yum-utils \
&&  yum clean all \
&&  rm -rf /var/cache/yum

# Initialize sandbox, get code, install build dependencies
# and fetch third parties
RUN repo init --no-clone-bundle -q -u https://github.com/Juniper/contrail-vnc -b r5.0 \
&&  repo sync --no-clone-bundle -q contrail-packages contrail-third-party \
&&  make -f tools/packages/Makefile dep \
&&  python third_party/fetch_packages.py \
&&  yum clean all \
&&  rm -rf /var/cache/yum

# DEVELOPMENT ENVIRONMENT TWEAKS
# contrail-kubernetes and contrail-config
RUN pip install --upgrade tox geventhttpclient

RUN echo export CONTRAIL=$CONTRAIL >> $HOME/.bashrc \
&&  echo export LD_LIBRARY_PATH=$CONTRAIL/build/lib >> $HOME/.bashrc

ADD Dockerfile $HOME/

