
FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN ./openwrt/scripts/prepare designated_driver openwrt.git cda52dcb329e02674175b60426be26cd813294a6 && \
 rm -rf .git && \
 chown -R builder:builder build
