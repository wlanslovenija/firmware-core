FROM wlanslovenija/firmware-base

MAINTAINER Jernej Kos <jernej@kos.mx>

ONBUILD VOLUME /buildsystem/build/builders
ONBUILD ADD ./arch /buildsystem/arch
ONBUILD RUN export FW_BUILDER_ARCH="$(cat /buildsystem/arch)" && \
 chown builder:builder /buildsystem/build/builders && \
 sudo -E -u builder ./scripts/build ${FW_BUILDER_ARCH} && \
 cd /buildsystem/build/release/${FW_BUILDER_ARCH} && \
 mkdir -p /builder/imagebuilder && \
 tar xf imagebuilder.${FW_BUILDER_ARCH}.tar.bz2 -C /builder/imagebuilder --strip-components 1 && \
 rm -f imagebuilder.${FW_BUILDER_ARCH}.tar.bz2 && \
 mv packages /builder/packages && \
 { rm -rf /buildsystem 2>/dev/null || true; }

