
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/firmware-base

RUN ./openwrt/scripts/prepare chaos_calmer 15.05/openwrt.git 160eb5da2835a99363c8ad37cf63df9d3347f7f3 && \
 rm -rf .git && \
 chown -R builder:builder build
