
########################################################################
# WARNING: This is an automatically generated Dockerfile. DO NOT EDIT. #
########################################################################

FROM wlanslovenija/lede-buildsystem:v17.01.4

RUN chown builder:builder /buildsystem/build && \
 sudo -E -u builder ./lede/scripts/configure-platform ramips_mt7628 && \
 sudo -E -u builder ./lede/scripts/build-toolchain && \
 sudo -E -u builder ./lede/scripts/build-imagebuilder && \
 export version="$(cat /buildsystem/build/lede/package/base-files/files/etc/version)" && \
 cd /buildsystem/build/release && \
 mkdir -p /builder/imagebuilder && \
 tar xf imagebuilder.tar.xz -C /builder/imagebuilder --strip-components 1 && \
 mv packages /builder/packages && \
 echo -n "{\"platform\": \"lede\", " > /builder/packages/metadata && \
 echo -n "\"architecture\": \"ramips_mt7628\", " >> /builder/packages/metadata && \
 echo -n "\"version\": \"${version}\", " >> /builder/packages/metadata && \
 echo -n "\"packages\": " >> /builder/packages/metadata && \
 find /builder/packages -name Packages | xargs cat | /buildsystem/lede/tools/packages2json.py >> /builder/packages/metadata && \
 echo "}" >> /builder/packages/metadata && \
 cp /buildsystem/lede/docker/Dockerfile.runtime /builder/Dockerfile && \
 { rm -rf /buildsystem 2>/dev/null || true; }

WORKDIR /builder
CMD tar cvzhf - .
