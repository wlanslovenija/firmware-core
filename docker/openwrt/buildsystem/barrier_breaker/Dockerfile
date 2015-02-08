
FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN ./openwrt/scripts/prepare barrier_breaker branches/barrier_breaker 44162 && \
 rm -rf .git && \
 chown -R builder:builder build
