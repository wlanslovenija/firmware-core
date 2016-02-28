
FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN ./openwrt/scripts/prepare chaos_calmer 15.05/openwrt.git a03a846c49c067048cd225d476a7adf91ef8ff03 && \
 rm -rf .git && \
 chown -R builder:builder build
