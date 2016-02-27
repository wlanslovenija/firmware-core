
FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN ./openwrt/scripts/prepare chaos_calmer branches/chaos_calmer 48792 && \
 rm -rf .git && \
 chown -R builder:builder build
