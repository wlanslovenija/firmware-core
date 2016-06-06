
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/firmware-base

RUN ./openwrt/scripts/prepare designated_driver openwrt.git cda52dcb329e02674175b60426be26cd813294a6 && \
 rm -rf .git && \
 chown -R builder:builder build
