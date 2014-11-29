FROM wlanslovenija/runit

MAINTAINER Jernej Kos <jernej@kos.mx>

EXPOSE 22/tcp
EXPOSE 80/tcp

RUN apt-get -q -q update && \
 apt-get --no-install-recommends --yes --force-yes install openssh-server nginx-light make && \
 useradd --home-dir /builder --shell /bin/bash --no-create-home builder && \
 sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ADD ./etc /etc
WORKDIR /builder
ENV HOME /builder

ONBUILD ADD . /builder
ONBUILD RUN chown -R builder:builder /builder/imagebuilder
