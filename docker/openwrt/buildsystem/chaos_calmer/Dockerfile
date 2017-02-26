
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/firmware-base

RUN ./openwrt/scripts/prepare chaos_calmer 15.05/openwrt.git 03d52cfcff87c0e8e09e7a455a6fdefb7138e369 && \
 rm -rf .git && \
 chown -R builder:builder build
