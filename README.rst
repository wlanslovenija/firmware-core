Firmware Builders for nodewatcher
=================================

This repository contains OpenWrt-based firmware builders for building
wlan slovenija firmware images. To ease deployment, the builders are 
provided as a set of Docker_ images.

Pre-built images are available on the public Docker Hub:

  * `wlanslovenija/firmware-base`_ (base image for all builders)
  * `wlanslovenija/openwrt-buildsystem`_ (base image for OpenWrt builders)
  * `wlanslovenija/openwrt-builder`_ (actual builders)

.. _Docker: https://www.docker.com
.. _wlanslovenija/firmware-base: https://registry.hub.docker.com/u/wlanslovenija/firmware-base/
.. _wlanslovenija/openwrt-buildsystem: https://registry.hub.docker.com/u/wlanslovenija/openwrt-buildsystem/
.. _wlanslovenija/openwrt-builder: https://registry.hub.docker.com/u/wlanslovenija/openwrt-builder/

Running builders
----------------

In order to run the Dockerized builder, for example ``wlanslovenija/openwrt-builder:v3fb97c2_bb_ar71xx``,
one simply needs to do the following::

  $ docker run -e "BUILDER_PUBLIC_KEY=ssh-rsa AAAA...2n builder@host" \
     wlanslovenija/openwrt-builder:v3fb97c2_bb_ar71xx

The ``BUILDER_PUBLIC_KEY`` environmental variable is used to specify the public key that will be
accepted for SSH authentication. In case one uses nodewatcher_, the corresponding private key needs
to be configured in its builder configuration.

.. _nodewatcher: http://nodewatcher.net

