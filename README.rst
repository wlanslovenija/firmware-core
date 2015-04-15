Firmware Builders for nodewatcher
=================================

This repository contains OpenWrt-based firmware builders for building
*nodewatcher* firmware images. To ease deployment, the builders are
provided as a set of Docker_ images.

Pre-built images are available on the public Docker Hub:

* `wlanslovenija/firmware-base`_ (base image for all builders)
* `wlanslovenija/openwrt-buildsystem`_ (base image for OpenWrt builders)
* `wlanslovenija/openwrt-builder`_ (actual builders)

.. _Docker: https://www.docker.com
.. _wlanslovenija/firmware-base: https://registry.hub.docker.com/u/wlanslovenija/firmware-base/
.. _wlanslovenija/openwrt-buildsystem: https://registry.hub.docker.com/u/wlanslovenija/openwrt-buildsystem/
.. _wlanslovenija/openwrt-builder: https://registry.hub.docker.com/u/wlanslovenija/openwrt-builder/

Running Builders
----------------

In order to run the Dockerized builder, for example ``wlanslovenija/openwrt-builder:v3fb97c2_bb_ar71xx``,
one simply needs to do the following::

  $ docker run -e "BUILDER_PUBLIC_KEY=ssh-rsa AAAA...2n builder@host" \
     wlanslovenija/openwrt-builder:v3fb97c2_bb_ar71xx

The ``BUILDER_PUBLIC_KEY`` environmental variable is used to specify the public key that will be
accepted for SSH authentication. In case one uses nodewatcher_, the corresponding private key needs
to be configured in its builder configuration.

.. _nodewatcher: http://nodewatcher.net

Building Images
---------------

You san SSH into the builder using the private keys which corresponds to the ``BUILDER_PUBLIC_KEY`` you provided.

Alternativelly, you can use Docker to connect to the running builder container locally::

    docker exec -t -i builder-openwrt-v3fb97c2-bb-ar71xx bash

Once you are in, you can build the image you are interested in. For example::

    cd /builder/imagebuilder
    su builder

    make image PROFILE="TLWR1043" PACKAGES="wireless-tools wpad-mini kmod-netem kmod-pktgen ntpclient qos-scripts iperf horst wireless-info cronscripts iwinfo nodewatcher-agent nodewatcher-agent-mod-general nodewatcher-agent-mod-resources nodewatcher-agent-mod-interfaces nodewatcher-agent-mod-wireless nodewatcher-agent-mod-keys_ssh nodewatcher-agent-mod-clients uhttpd ip-full"

You can use only packages which were premade when creating this builder. You `cannot compile custom packages at this step anymore`__.

Resulting image will be in ``/builder/imagebuilder/bin/ar71xx/``.

__ `Build System Internals`_

Accessing Built Images
----------------------

You can use ``scp`` to copy the image out. Alternativelly, you can use Docker::

    docker cp builder-openwrt-v3fb97c2-bb-ar71xx:/builder/imagebuilder/bin/ar71xx/openwrt-ar71xx-generic-tl-wr1043nd-v1-squashfs-factory.bin .

Accessing OPKG Packages
-----------------------

Builders contain an HTTP server which you can use to offer OPKG_ packages.

.. _OPKG: http://wiki.openwrt.org/doc/techref/opkg

If we assume that your builder container is available directly on ``example.com``, then you could add to ``/etc/opkg.conf``
the following package repositories::

    src/gz barrier_breaker_base http://example.com/base
    src/gz barrier_breaker_nodewatcher http://example.com/nodewatcher
    src/gz barrier_breaker_openwrt http://example.com/openwrt
    src/gz barrier_breaker_openwrtlegacy http://example.com/openwrtlegacy
    src/gz barrier_breaker_routing http://example.com/routing

Of course probably you want to use some reverse HTTP proxy in front and make the URLs more like::

    src/gz barrier_breaker_base http://example.com/firmware/git.3fb97c2/openwrt/barrier_breaker/ar71xx/base
    src/gz barrier_breaker_nodewatcher http://example.com/firmware/git.3fb97c2/openwrt/barrier_breaker/ar71xx/nodewatcher
    src/gz barrier_breaker_openwrt http://example.com/firmware/git.3fb97c2/openwrt/barrier_breaker/ar71xx/openwrt
    src/gz barrier_breaker_openwrtlegacy http://example.com/firmware/git.3fb97c2/openwrt/barrier_breaker/ar71xx/openwrtlegacy
    src/gz barrier_breaker_routing http://example.com/firmware/git.3fb97c2/openwrt/barrier_breaker/ar71xx/routing

This is also how nodewatcher does it. See that builder's git revision, OpenWrt release, and platform are parts of the URL.

OpenWrt Cloud Builder API
-------------------------

The following is the OpenWrt Cloud Builder API 0.1 standard. We are proposing it to facilitate easy sharing, reuse,
and swapping of builders and testing out of new firmwares in the wider OpenWrt community.

* There is a system user ``builder`` under which you should be running the build.
* OpenWrt image builder system is available under ``/builder/imagebuilder/``.

To facilitate the cloud use of builders the following is optional, but recommended.

* OpenWrt packages are available through the builder over HTTP with feeds directly under the HTTP root so ``packages`` feed is available under ``/packages/``.
* A metadata file served over HTTP at ``/metadata``, encoded as a JSON object with the following fields:

  * ``platform`` which should be ``"openwrt"``.
  * ``architecture`` which should contain the name of the architecture the builder is for (for example ``"ar71xx"``).
  * ``version`` which should contain a string identifying the version of the builder (for example ``"git.3fb97c2"``).

* Support for SSH access using the ``BUILDER_PUBLIC_KEY`` to authenticate the client connection.

Build System Internals
----------------------

The build system is composed from multiple Docker images. Some of them are hardcoded and the others are
generated using scripts. While currently only the OpenWrt platform is supported, the build system is
designed so it could support others as well. OpenWrt-specific build configuration is under ``openwrt/``, for
example the file ``openwrt/packages`` specifies which packages get compiled.

The docker images for the build process are the following:

* ``firmware-base`` (the top-level Dockerfile) prepares a minimal environment with required
  dependencies to build stuff.

* ``firmware-runtime`` (in ``docker/runtime``) prepares a minimal environment used to run (not
  build) the final OpenWrt image builder images. It sets up an HTTP and SSH servers that are used
  by nodewatcher to connect to the container and build the images. The HTTP server is also used to
  serve the built OPKG packages.

These two are the only Dockerfiles that are hardcoded, all the others are generated by the above scripts and
the generated files are stored in the ``docker/openwrt`` subdirectory. Calling ``create-dockerfiles`` will
overwrite anything in this directory, so it shouldn't be edited by hand.

* ``openwrt-buildsystem`` inherits from ``firmware-base`` and comes in multiple tags (one for each OpenWrt
  branch we support, currently these are  Barrier Breaker and Chaos Calmer). This image contains a complete
  OpenWrt buildsystem, prepared for building our firmware (we configure some special feeds and apply some
  atches). The image does not build anything, it just prepares it so that further stages can use it.

* ``openwrt-builder-stage-1`` inherits from ``openwrt-buildsystem`` and comes in multiple tags (one for each
  combination of OpenWrt branch and architecture that we support). This image is internal and is not
  published in the Docker hub as it would be too big (it contains the complete built OpenWrt toolchain). The
  stage 1 builder uses the prepared buildsystem to build the OpenWrt image builders.

* ``openwrt-builder`` inherits from ``firmware-runtime`` and is generated from the respective
  ``openwrt-builder-stage-1`` by the ``create-runtime`` script. It also comes in multiple tags, one for each
  combination of firmware version, OpenWrt branch and architecture that we support. This Docker image
  contains the OpenWrt image builder that can be used to quickly generate firmware images without needing
  to compile anything.

Source Code, Issue Tracker and Mailing List
-------------------------------------------

For development *wlan slovenija* open wireless network `development Trac`_ is
used, so you can see `existing open tickets`_ or `open a new one`_ there. Source
code is available on GitHub_. If you have any questions or if you want to
discuss the project, use `development mailing list`_.

.. _development Trac: https://dev.wlan-si.net/
.. _existing open tickets: https://dev.wlan-si.net/report
.. _open a new one: https://dev.wlan-si.net/newticket
.. _GitHub: https://github.com/wlanslovenija/firmware-core
.. _development mailing list: https://wlan-si.net/lists/info/development
