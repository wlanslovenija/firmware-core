FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

ONBUILD VOLUME /buildsystem/build/builders
ONBUILD ADD ./arch /buildsystem/arch
ONBUILD RUN export FW_BUILDER_ARCH="$(cat /buildsystem/arch)" && \
 export FW_BUILDER_VER="$(cat /buildsystem/build/openwrt/package/base-files/files/etc/version)" && \
 chown builder:builder /buildsystem/build/builders && \
 sudo -E -u builder ./scripts/build ${FW_BUILDER_ARCH} && \
 cd /buildsystem/build/release/${FW_BUILDER_ARCH} && \
 mkdir -p /builder/imagebuilder && \
 tar xf imagebuilder.${FW_BUILDER_ARCH}.tar.bz2 -C /builder/imagebuilder --strip-components 1 && \
 chown -R builder:builder /builder/imagebuilder && \
 rm -f imagebuilder.${FW_BUILDER_ARCH}.tar.bz2 && \
 mv packages /builder/packages && \
 echo -n "{\"platform\": \"openwrt\", " > /builder/packages/metadata && \
 echo -n "\"architecture\": \"${FW_BUILDER_ARCH}\", " >> /builder/packages/metadata && \
 echo "\"version\": \"${FW_BUILDER_VER}\"}" >> /builder/packages/metadata && \
 { rm -rf /buildsystem 2>/dev/null || true; }

