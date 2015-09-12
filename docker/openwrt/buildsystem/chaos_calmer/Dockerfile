
FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN ./openwrt/scripts/prepare chaos_calmer branches/chaos_calmer 46849 && \
 rm -rf .git && \
 chown -R builder:builder build
