FROM tozd/runit:ubuntu-bionic

MAINTAINER Robert Marko <robimarko@gmail.com>

EXPOSE 22/tcp
EXPOSE 80/tcp

RUN apt-get -q -q update && \
 apt-get --no-install-recommends --yes --force-yes install \
 openssh-server nginx-light build-essential libncurses5-dev openssl wget libsigsegv2 perl-doc \
 gawk unzip git python bsdmainutils && \
 useradd --home-dir /builder --shell /bin/bash --no-create-home builder && \
 sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ADD ./etc /etc
WORKDIR /builder
ENV HOME /builder

ONBUILD ADD . /builder
ONBUILD RUN chown -R builder:builder /builder/imagebuilder
