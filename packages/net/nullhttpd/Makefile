include $(TOPDIR)/rules.mk

PKG_NAME:=nullhttpd
PKG_VERSION:=0.1
PKG_RELEASE:=8
PKG_REV:=tip

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://dev.wlan-si.net/hg/packages/nullhttpd
PKG_SOURCE_PROTO:=hg
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)

include $(INCLUDE_DIR)/package.mk

define Package/nullhttpd
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+nodewatcher-core
  TITLE:=Null HTTP daemon
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	mv $(PKG_BUILD_DIR)/src/* $(PKG_BUILD_DIR)
endef

define Package/nullhttpd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nullhttpd $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/nullhttpd.init $(1)/etc/init.d/nullhttpd
endef

$(eval $(call BuildPackage,nullhttpd))
