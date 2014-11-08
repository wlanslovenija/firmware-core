FROM wlanslovenija/runit

MAINTAINER Jernej Kos <jernej@kos.mx>

EXPOSE 22/tcp
EXPOSE 80/tcp

ADD . /buildsystem
WORKDIR /buildsystem
ENV HOME /buildsystem

RUN apt-get -q -q update && \
 apt-get --no-install-recommends --yes --force-yes install \
 build-essential git subversion quilt gawk unzip python wget zlib1g-dev libncurses5-dev \
 fakeroot ca-certificates openssh-server nginx-light && \
 useradd --home-dir /builder --shell /bin/bash --no-create-home builder && \
 RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ADD ./docker/base/etc /etc

ONBUILD ADD ./platform /buildsystem/platform
ONBUILD ADD ./version /buildsystem/version
ONBUILD RUN export FW_PLATFORM="$(cat platform)" && \
 mv version "/buildsystem/${FW_PLATFORM}/version" && \
 ./scripts/prepare ${FW_PLATFORM} && \
 rm -rf .git && \
 chown -R builder:builder build

