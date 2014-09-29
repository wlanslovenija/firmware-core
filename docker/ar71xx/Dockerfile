FROM wlanslovenija/firmware-core:latest

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN sudo -E -u nobody ./scripts/build ar71xx && \
 cd /buildsystem/build/release/ar71xx && \
 mkdir builder && \
 tar xf imagebuilder.ar71xx.tar.bz2 -C builder --strip-components 1 && \
 rm -f imagebuilder.ar71xx.tar.bz2

