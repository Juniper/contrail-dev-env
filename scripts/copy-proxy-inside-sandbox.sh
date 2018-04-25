#!/bin/bash

if [ ! -d /root/.m2 ];
    then mkdir /root/.m2;
fi

if [ -f /root/contrail-dev-env/settings.xml ] && [ ! -f /root/.m2/settings.xml ];
    then cp /root/contrail-dev-env/settings.xml /root/.m2/settings.xml;
fi

if [ -f /root/contrail-dev-env/environment ] && [ ! -f /etc/environment ];
    then cp /root/contrail-dev-env/environment /etc/environment;
fi

