
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/openwrt-buildsystem:chaos_calmer

RUN chown builder:builder /buildsystem/build && \
 sudo -E -u builder ./openwrt/scripts/configure-platform brcm2708 && \
 sudo -E -u builder ./openwrt/scripts/build-toolchain && \
 sudo -E -u builder ./openwrt/scripts/build-imagebuilder && \
 export version="$(cat /buildsystem/build/openwrt/package/base-files/files/etc/version)" && \
 cd /buildsystem/build/release && \
 mkdir -p /builder/imagebuilder && \
 tar xf imagebuilder.tar.bz2 -C /builder/imagebuilder --strip-components 1 && \
 mv packages /builder/packages && \
 echo -n "{\"platform\": \"openwrt\", " > /builder/packages/metadata && \
 echo -n "\"architecture\": \"brcm2708\", " >> /builder/packages/metadata && \
 echo -n "\"version\": \"${version}\", " >> /builder/packages/metadata && \
 echo -n "\"packages\": " >> /builder/packages/metadata && \
 find /builder/packages -name Packages | xargs cat | /buildsystem/openwrt/tools/packages2json.py >> /builder/packages/metadata && \
 echo "}" >> /builder/packages/metadata && \
 cp /buildsystem/openwrt/docker/Dockerfile.runtime /builder/Dockerfile && \
 { rm -rf /buildsystem 2>/dev/null || true; }

WORKDIR /builder
CMD tar cvzhf - .
