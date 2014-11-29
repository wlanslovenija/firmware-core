
FROM wlanslovenija/openwrt-buildsystem:barrier_breaker

MAINTAINER Jernej Kos <jernej@kos.mx>

RUN chown builder:builder /buildsystem/build && \
 sudo -E -u builder ./openwrt/scripts/configure-platform x86_hyperv && \
 sudo -E -u builder ./openwrt/scripts/build-toolchain && \
 sudo -E -u builder ./openwrt/scripts/build-imagebuilder && \
 export version="$(cat /buildsystem/build/openwrt/package/base-files/files/etc/version)" && \
 cd /buildsystem/build/release && \
 mkdir -p /builder/imagebuilder && \
 tar xf imagebuilder.tar.bz2 -C /builder/imagebuilder --strip-components 1 && \
 mv packages /builder/packages && \
 echo -n "{\"platform\": \"openwrt\", " > /builder/packages/metadata && \
 echo -n "\"architecture\": \"x86_hyperv\", " >> /builder/packages/metadata && \
 echo "\"version\": \"${version}\"}" >> /builder/packages/metadata && \
 cp /buildsystem/openwrt/docker/Dockerfile.runtime /builder/Dockerfile && \
 { rm -rf /buildsystem 2>/dev/null || true; }

WORKDIR /builder
CMD tar cvzhf - .
