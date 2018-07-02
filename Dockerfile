FROM tozd/base:ubuntu-bionic

RUN apt-get -q -q update && \
 apt-get --no-install-recommends --yes --force-yes install \
 subversion g++ zlib1g-dev build-essential git python rsync man-db quilt curl \
 libncurses5-dev gawk gettext unzip file libssl-dev wget zip time ca-certificates && \
 useradd --home-dir /builder --shell /bin/bash --no-create-home builder

WORKDIR /buildsystem
ENV HOME /buildsystem
ADD . /buildsystem
