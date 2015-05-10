
FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN ./openwrt/scripts/prepare chaos_calmer trunk 45656 && \
 rm -rf .git && \
 chown -R builder:builder build
