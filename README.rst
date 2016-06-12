Firmware Builders for nodewatcher
=================================

This repository contains OpenWrt-based firmware builders for building
default *nodewatcher* firmware images. We use this firmware in the
*wlan slovenija* network and you can use it directly or use it as a base
for your own firmware.
To ease deployment, the builders are
provided as a set of Docker_ images.

Pre-built images are available on the public Docker Hub:

* `wlanslovenija/firmware-base`_ (base image for all builders)
* `wlanslovenija/openwrt-buildsystem`_ (base image for OpenWrt builders)
* `wlanslovenija/openwrt-builder`_ (actual builders)

.. _Docker: https://www.docker.com
.. _wlanslovenija/firmware-base: https://registry.hub.docker.com/u/wlanslovenija/firmware-base/
.. _wlanslovenija/openwrt-buildsystem: https://registry.hub.docker.com/u/wlanslovenija/openwrt-buildsystem/
.. _wlanslovenija/openwrt-builder: https://registry.hub.docker.com/u/wlanslovenija/openwrt-builder/

.. note::
    When nodewatcher_ is generating firmware images, it specifies the profile, packages, and configuration
    files automatically. The commands described below are used only when developing, testing, or using
    firmware builders without nodewatcher.

Running Builders
----------------

In order to run the Dockerized builder, for example ``wlanslovenija/openwrt-builder:vb106cfb_cc_ar71xx``,
one simply needs to do the following::

  $ docker run --detach=true --name builder-openwrt-vb106cfb_cc_ar71xx \
     --env "BUILDER_PUBLIC_KEY=ssh-rsa AAAA...2n builder@host" \
     wlanslovenija/openwrt-builder:vb106cfb_cc_ar71xx

The ``BUILDER_PUBLIC_KEY`` environmental variable is used to specify the public key that will be
accepted for SSH authentication. In case one uses nodewatcher_, the corresponding private key needs
to be configured in its builder configuration.

We pre-build and publish ``wlanslovenija/openwrt-builder`` images with `multiple tags for different versions and platforms`_.
Tag is in the format ``v<commit hash>_<OpenWrt release>_<platform>``. For example, ``vb106cfb_cc_ar71xx``
corresponds to the firmware at `b106cfb commit`_ of this repository, for the OpenWrt Chaos Calmer release,
for the ``ar71xx`` platform.

.. _nodewatcher: http://nodewatcher.net
.. _multiple tags for different versions and platforms: https://hub.docker.com/r/wlanslovenija/openwrt-builder/tags/
.. _b106cfb commit: https://github.com/wlanslovenija/firmware-core/commit/b106cfb0a8f35d1af09a75e02fb245ffef449868

Building Images
---------------

One running, you san SSH into the builder using the private keys which corresponds to the ``BUILDER_PUBLIC_KEY``
you provided.

Alternatively, you can use Docker to connect to the running builder container locally::

    docker exec -t -i builder-openwrt-vb106cfb_cc_ar71xx bash

Once you are in, you can build the image you are interested in. For example::

    cd /builder/imagebuilder
    su builder

    make image PROFILE="TLWR1043" PACKAGES="wireless-tools wpad-mini kmod-netem kmod-pktgen ntpclient qos-scripts iperf horst wireless-info cronscripts iwinfo nodewatcher-agent nodewatcher-agent-mod-general nodewatcher-agent-mod-resources nodewatcher-agent-mod-interfaces nodewatcher-agent-mod-wireless nodewatcher-agent-mod-keys_ssh nodewatcher-agent-mod-clients uhttpd ip-full"

You can use only packages which were made when creating this builder (are listed in the ``openwrt/packages`` file).
You `cannot compile custom packages at this step anymore`_.
If you need additional packages, you have to `modify the firmware builders`_.

Resulting image will be in ``/builder/imagebuilder/bin/ar71xx/``.

.. _modify the firmware builders: modifying-firmware-builders_
.. _cannot compile custom packages at this step anymore: build-system-internals_

Accessing Built Images
----------------------

You can use ``scp`` to copy the image out. Alternatively, you can use Docker::

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

* ``branches`` contains a list of OpenWrt git branches and their commit hashes that should be compiled.

  Each branch definition is in the format ``LONG_NAME:GIT_PATH:GIT_REVISION:SHORT_NAME`` where fields are as follows:

  * ``LONG_NAME`` is a lowercased OpenWrt distribution name (eg. ``chaos_calmer``).

  * ``GIT_PATH`` is a path relative to `git.openwrt.org`_ (eg. ``15.05/openwrt.git``).

  * ``GIT_REVISION`` is a commit hash or branch name.

  * ``SHORT_NAME`` is a two-letter lowercased OpenWrt short distribution name (eg. ``cc``).

  If you need to support a new version of OpenWrt (new branch) or bump the revision of an existing branch, you must
  first edit this file.

* ``architectures`` contains a list of OpenWrt architectures that should be built. Each architecture listed here is
  configured inside ``configs/<architecture>``.

* ``configs`` contains an OpenWrt configuration (``.config``) for each of the architectures. These ``.config`` files
  are the usual format for configuring the Linux kernel.

  There is a special configuration called ``generic``, which is merged into configurations of all other architectures
  before building. Configuration for each architecture should contain the minimum amount of options needed to
  successfully build OpenWrt. All options, which are not specified, will be automatically set to default values and
  in this case you should not specify them.

  Also, be sure to specify only architecture-specific configuration in these files. All general configuration, which
  should be applied to all architectures, should go into the generic file.

* ``feeds`` contains a list of OpenWrt package feeds for each of the branches.

  Each branch has its own file named ``LONG_NAME`` (eg. ``feeds/chaos_calmer``).

  The format of each file is the same as ``feeds.conf`` in OpenWrt.

* ``patches`` contains patches that should be applied to the OpenWrt tree before building.

  Each branch has its own directory named ``LONG_NAME`` (eg. ``patches/chaos_calmer/``).

  The directory contains patch files and a series file, as required by `quilt`_.

* ``packages`` contains a list of packages that should be built.

  The list may contain any package included in the base distribution and may also contain any packages contained in configured feeds.

  The list of packages is currently the same for all branches and architectures. If you need architecture-specific packages, those
  should be specified in the architecture configuration file.

After you make any changes to the above configuration, you must first run ``./openwrt/scripts/generate-dockerfiles`` to
update the Dockerfiles, which are used to build the firmware.
You should commit those updated files under ``docker`` directory to the repository together with your other changes.

Relationships of the various Dockerfiles are explained in `Build System Internals`_.

Before building anything, ensure that you have the latest version of ``wlanslovenija/firmware-base`` and
``wlanslovenija/firmware-runtime`` images locally by running::

    docker pull wlanslovenija/firmware-base
    docker pull wlanslovenija/firmware-runtime

The next step is to build the correct ``wlanslovenija/openwrt-buildsystem`` image. There is a script that makes this
easier, so you can run::

    ./openwrt/scripts/docker-build-buildsystem <LONG_NAME>

For example, to build for the Chaos Calmer branch, run::

    ./openwrt/scripts/docker-build-buildsystem chaos_calmer

After the build completes successfully, you may then build the stage 1 builder (``wlanslovenija/openwrt-builder-stage-1``)
for your specific architecture. There is a script that makes this easier, so you can run::

    ./openwrt/scripts/docker-build-stage-1 <LONG_NAME> <ARCHITECTURE>

For example, to build for the ar71xx architecture of Chaos Calmer, run::

    ./openwrt/scripts/docker-build-stage-1 chaos_calmer ar71xx

After the build completes successfully, you may proceed with building the actual image builder, which may be used by
nodewatcher. There is a script that makes this easier, so you can run::

    ./openwrt/scripts/docker-build-builders -b <LONG_NAME> -a <ARCHITECTURE>

For example::

    ./openwrt/scripts/docker-build-builders -b chaos_calmer -a ar71xx

Then, a Docker image named ``wlanslovenija/openwrt-builder:vXXXXXXX_cc_ar71xx`` will be available, where ``XXXXXXX``
will be the current git revision of the local ``firmware-core`` repository.

You can now run and use the new image in the same way as pre-built images. You can use them directly, or through
nodewatcher.
If you are adding support for a new device, you have add to nodewatcher also a new `device descriptor`_.
Add it to your local instance of nodewatcher and test it by generating an image through nodewatcher for this new device,
flashing it, and testing it, to make sure everything works as intended.
If it does, then contribute both changes to this repository and your new device descriptor back so that it is
available to others as well.

.. _git.openwrt.org: https://git.openwrt.org/
.. _quilt: https://savannah.nongnu.org/projects/quilt
.. _device descriptor: https://nodewatcher.readthedocs.io/en/development/cgm.html#device-descriptors

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
  ``openwrt-builder-stage-1`` by the ``docker-build-builders`` script. It also comes in multiple tags, one for each
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
