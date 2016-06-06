
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/firmware-base

RUN ./openwrt/scripts/prepare chaos_calmer 15.05/openwrt.git 88ef6c4258fe7201678c3862d9a4f0da391a5155 && \
 rm -rf .git && \
 chown -R builder:builder build
