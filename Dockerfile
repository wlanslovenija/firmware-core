FROM wlanslovenija/base

MAINTAINER Jernej Kos <jernej@kos.mx>

ADD . /buildsystem
WORKDIR /buildsystem

RUN apt-get -q -q update && \
 apt-get --no-install-recommends --yes --force-yes install \
 build-essential git subversion quilt gawk unzip python wget zlib1g-dev libncurses5-dev \
 fakeroot ca-certificates && \
 ./scripts/prepare && \
 rm -rf .git && \
 chown -R nobody:nogroup build

ENTRYPOINT ["sudo", "-E", "-u", "nobody", "--"]

