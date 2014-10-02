FROM wlanslovenija/runit

MAINTAINER Jernej Kos <jernej@kos.mx>

ADD . /buildsystem
WORKDIR /buildsystem
ENV HOME /buildsystem

RUN apt-get -q -q update && \
 apt-get --no-install-recommends --yes --force-yes install \
 build-essential git subversion quilt gawk unzip python wget zlib1g-dev libncurses5-dev \
 fakeroot ca-certificates openssh-server nginx-light && \
 useradd --home-dir /builder --shell /bin/bash --no-create-home builder

ADD ./docker/base/etc /etc

ONBUILD ADD ./version /buildsystem/openwrt/version
ONBUILD RUN ./scripts/prepare && \
 rm -rf .git && \
 chown -R builder:builder build

