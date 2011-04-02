#
# Copyright (C) 2007 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id: Makefile 9695 2007-12-09 18:59:01Z nbd $

include $(TOPDIR)/rules.mk

PKG_NAME:=netprofscripts
PKG_VERSION:=0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/netprofscripts
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+busybox
  TITLE:=Network profiling scripts
  URL:=
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/netprofscripts/install
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_BIN) ./files/httpd.null $(1)/www/cgi-bin/null
	$(INSTALL_BIN) ./files/httpd.urandom $(1)/www/cgi-bin/urandom
	$(INSTALL_BIN) ./files/httpd.zero $(1)/www/cgi-bin/zero
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/wput $(1)/usr/bin/wput
endef

$(eval $(call BuildPackage,netprofscripts))
