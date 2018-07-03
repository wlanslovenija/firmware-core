
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/firmware-base

RUN ./openwrt/scripts/prepare v17.01.4 openwrt.git 444add156f2a6d92fc15005c5ade2208a978966c && \
 rm -rf .git && \
 chown -R builder:builder build
