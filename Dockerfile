FROM wlanslovenija/base

MAINTAINER Jernej Kos <jernej@kos.mx>

ENV FW_PACKAGE_HOST packages.wlan-si.net

RUN apt-get -q -q update && \
 apt-get --no-install-recommends --yes --force-yes install \
 build-essential git subversion quilt gawk unzip python wget zlib1g-dev libncurses5-dev \
 fakeroot ca-certificates && \
 useradd --home-dir /builder --shell /bin/bash --no-create-home builder

WORKDIR /buildsystem
ENV HOME /buildsystem
ADD . /buildsystem
