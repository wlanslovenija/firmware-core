
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/firmware-base

RUN ./lede/scripts/prepare master source.git 98fb380d8855f7d6b94f3be791331adaa3d88a2a && \
 rm -rf .git && \
 chown -R builder:builder build
