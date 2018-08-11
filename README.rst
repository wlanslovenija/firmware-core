Firmware Builders for nodewatcher
=================================

This repository contains OpenWrt based firmware builders for building
default *nodewatcher* firmware images. We use this firmware in the
*wlan slovenija* network and you can use it directly or use it as a base
for your own firmware. To ease deployment, the builders are provided as
a set of Docker_ images.

Pre-built images are available on the public Docker Hub:

* `wlanslovenija/firmware-base`_ (base image for all builders)
* `wlanslovenija/openwrt-imagebuilder-base`_ (base image for OpenWrt builders)
* `wlanslovenija/openwrt-builder`_ (actual OpenWrt builders)

Most of the changes to the stock OpenWrt firmware we do are available through
`opkg packages`_.

.. _Docker: https://www.docker.com
.. _wlanslovenija/firmware-base: https://registry.hub.docker.com/u/wlanslovenija/firmware-base/
.. _wlanslovenija/openwrt-imagebuilder-base: https://registry.hub.docker.com/u/wlanslovenija/openwrt-imagebuilder-base/
.. _wlanslovenija/openwrt-builder: https://registry.hub.docker.com/u/wlanslovenija/openwrt-builder/
.. _opkg packages: https://github.com/wlanslovenija/firmware-packages-opkg

.. note::
    When nodewatcher_ is generating firmware images, it specifies the profile, packages, and configuration
    files automatically. The commands described below are used only when developing, testing, or using
    firmware builders without nodewatcher.

Running Builders
----------------

In order to run the Dockerized builder, for example ``wlanslovenija/openwrt-builder:18.06.0_ar71xx_generic``,
one simply needs to do the following::

  $ docker run --detach=true --name builder-openwrt-18.06.0_ar71xx_generic \
     --env "BUILDER_PUBLIC_KEY=ssh-rsa AAAA...2n builder@host" \
     wlanslovenija/openwrt-builder:18.06.0_ar71xx_generic

The ``BUILDER_PUBLIC_KEY`` environmental variable is used to specify the public key that will be
accepted for SSH authentication. In case one uses nodewatcher_, the corresponding private key needs
to be configured in its builder configuration.

We pre-build and publish ``wlanslovenija/openwrt-builder`` images with `multiple tags for different versions and platforms`_.
Tag is in the format ``<OpenWrt release>_<target>_<subtarget>``. For example, ``18.06.0_ar71xx_generic``
corresponds to the firmware at tag `18.06.0` of OpenWrt repository, for the OpenWrt 18.06.0 release,
for the ``ar71xx`` target and ``generic`` subtarget.

.. _nodewatcher: http://nodewatcher.net
.. _multiple tags for different versions and platforms: https://hub.docker.com/r/wlanslovenija/openwrt-builder/tags/

Building Images
---------------

One running, you san SSH into the builder using the private keys which corresponds to the ``BUILDER_PUBLIC_KEY``
you provided.

Alternatively, you can use Docker to connect to the running builder container locally::

    docker exec -t -i builder-openwrt-18.06.0_ar71xx_generic bash

Once you are in, you can build the image you are interested in. For example::

    cd /builder/imagebuilder
    su builder

    make image PROFILE="TLWR1043" PACKAGES="wireless-tools wpad-mini kmod-netem kmod-pktgen ntpclient qos-scripts iperf horst wireless-info cronscripts iwinfo nodewatcher-agent nodewatcher-agent-mod-general nodewatcher-agent-mod-resources nodewatcher-agent-mod-interfaces nodewatcher-agent-mod-wireless nodewatcher-agent-mod-keys_ssh nodewatcher-agent-mod-clients uhttpd ip-full"

You can use only packages which were made when creating this builder (are listed in the ``openwrt/packages`` file).
You `cannot compile custom packages at this step anymore`_.
If you need additional packages, you have to `modify the firmware builders`_.

Resulting image will be in ``/builder/imagebuilder/bin/ar71xx/generic/``.

.. _modify the firmware builders: modifying-firmware-builders_
.. _cannot compile custom packages at this step anymore: build-system-internals_

Accessing Built Images
----------------------

You can use ``scp`` to copy the image out. Alternatively, you can use Docker::

    docker cp builder-openwrt-18.06.0_ar71xx_generic:/builder/imagebuilder/bin/ar71xx/generic/openwrt-ar71xx-generic-tl-wr1043nd-v1-squashfs-factory.bin .

.. _modifying-firmware-builders:

Modifying Firmware Builders
---------------------------

If you want to modify firmware builders to generate somehow different OpenWrt firmware, you should first make sure
that firmware image works for you when it is generated directly through `normal OpenWrt firmware building process`_.
Firmware builders are not suitable environment for development of OpenWrt firmware itself.
Once you have a working firmware image you want you can proceed with modifying firmware builders to build
this new firmware for you.
Instead of using pre-built Docker images from Docker Hub you will now have to build Docker images for
new firmware builders yourself.

.. _normal OpenWrt firmware building process: https://wiki.openwrt.org/doc/howto/build

OpenWRt firmware builders are defined through configuration files found under ``openwrt`` directory:

* ``packages`` contains a list of WlanSlovenija custom packages that Nodewatcher uses and that will be compiled.

  Each branch definition is in the format ``OpenWrt_Release:OpenWrt_Target:OpenWrt_SubTarget`` where fields are as follows:

  * ``OpenWrt_Release`` is a OpenWrt release version (eg. ``18.06.0`` for stable or ``snapshot`` for snapshots).

  * ``OpenWrt_Target`` is a OpenWrt target relative to `OpenWrt downloads`_ (eg. ``ar71xx``).

  * ``OpenWrt_SubTarget`` is a OpenWrt subtarget to `OpenWrt downloads`_ (eg. ``generic``).

Relationships of the various Dockerfiles are explained in `Build System Internals`_.

The next step is to build the correct ``wlanslovenija/openwrt-builder`` image. There is a script that makes this
easier, so you can run::

    sudo ./openwrt/scripts/build <OpenWrt_Release> <OpenWrt_Target> <OpenWrt_SubTarget>

For example, to build for the 18.06.0 release for the ar71xx target and generic subtarget, run::

    sudo ./openwrt/scripts/build 18.06.0 ar71xx generic

After the build completes successfully,then, a Docker image named ``wlanslovenija/openwrt-builder:18.06.0_ar71xx_generic`` will be available.

You can now run and use the new image in the same way as pre-built images. You can use them directly, or through
nodewatcher.
If you are adding support for a new device, you have add to nodewatcher also a new `device descriptor`_.
Add it to your local instance of nodewatcher and test it by generating an image through nodewatcher for this new device,
flashing it, and testing it, to make sure everything works as intended.
If it does, then contribute both changes to this repository and your new device descriptor back so that it is
available to others as well.

.. _OpenWrt downloads: http://downloads.openwrt.org/
.. _device descriptor: https://nodewatcher.readthedocs.io/en/development/cgm.html#device-descriptors

Cloud Builder API
-----------------

The following is the Cloud Builder API 0.1 standard. We are proposing it to facilitate easy sharing, reuse,
and swapping of builders and testing out of new firmwares in the wider community.

* There is a system user ``builder`` under which you should be running the build.
* OpenWrt image builder systems are available under ``/builder/imagebuilder/``.

To facilitate the cloud use of builders the following is optional, but recommended.

* OpenWrt packages are available through the builder over HTTP with feeds directly under the HTTP root so ``packages`` feed is available under ``/packages/``.
* A metadata file served over HTTP at ``/metadata``, encoded as a JSON object with the following fields:

  * ``platform`` which should be ``"openwrt"``.
  * ``architecture`` which should contain the name of the architecture the builder is for (for example ``"ar71xx"``).
  * ``version`` which should contain a string identifying the version of the builder (for example ``"18.06.0"``).
  * ``packages`` which should contain an object describing included package information. Keys should be
    package names and each package is represented by an object with the following fields:

    * ``name``
    * ``version``
    * ``dependencies``
    * ``source``
    * ``size``
    * ``size_installed``
    * ``checksum_md5``
    * ``checksum_sha256``
    * ``description``

* Support for SSH access using the ``BUILDER_PUBLIC_KEY`` to authenticate the client connection.

.. _build-system-internals:

Build System Internals
----------------------

The build system is composed from multiple Docker images. Some of them are hardcoded and the others are
generated using scripts. While currently only the OpenWrt platform is supported, the build system is
designed so it could support others as well. For example, OpenWrt-specific build configuration is under ``openwrt/``, for
example the file ``openwrt/packages`` specifies which packages get compiled.

The docker images for the build process are the following:

* ``firmware-base`` (the top-level Dockerfile) prepares a minimal environment with required
  dependencies to build stuff.

* ``firmware-runtime`` (in ``docker/runtime``) prepares a minimal environment used to run (not
  build) the final OpenWrt image builder images. It sets up an HTTP and SSH servers that are used
  by nodewatcher to connect to the container and build the images. The HTTP server is also used to
  serve the built OPKG packages.

These two are the only Dockerfiles that are hardcoded, all the others are generated by the above scripts and
the generated files are stored in the ``docker/openwrt`` subdirectory. Calling ``./openwrt/scripts/generate-dockerfiles`` will
overwrite anything in this directory, so it shouldn't be edited by hand.

For OpenWrt, the following Docker images are used:

* ``openwrt-buildsystem`` inherits from ``firmware-base`` and comes in multiple tags (one for each OpenWrt
  branch we support, currently these are  Barrier Breaker and Chaos Calmer). This image contains a complete
  OpenWrt buildsystem, prepared for building our firmware (we configure some special feeds and apply some
  atches). The image does not build anything, it just prepares it so that further stages can use it.

* ``openwrt-imagebuilder-base`` inherits from ``openwrt-buildsystem`` and comes in multiple tags (one for each
  combination of OpenWrt branch and architecture that we support). This image is internal and is not
  published in the Docker hub as it would be too big (it contains the complete built OpenWrt toolchain). The
  stage 1 builder uses the prepared buildsystem to build the OpenWrt image builders.

* ``openwrt-builder`` inherits from ``firmware-runtime`` and is generated from the respective
  ``openwrt-imagebuilder-base`` by the ``docker-build-builders`` script. It also comes in multiple tags, one for each
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
