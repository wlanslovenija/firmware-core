FROM wlanslovenija/firmware-core:latest

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN sudo -E -u nobody ./scripts/build ar71xx && \
 mkdir /buildsystem/build/release/ar71xx/builder && \
 tar xf imagebuilder.ar71xx.tar.bz2 -C /buildsystem/build/release/ar71xx/builder --strip-components 1

