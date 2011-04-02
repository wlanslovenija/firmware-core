include $(TOPDIR)/rules.mk

PKG_NAME:=nodewatcher-watchdog
PKG_VERSION:=0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/nodewatcher-watchdog
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+nodewatcher-core +cronscripts
  TITLE:=nodewatcher-watchdog
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/nodewatcher-watchdog/install
	# Sanity checks
	$(INSTALL_DIR) $(1)/etc/crontabs/run.5
	$(INSTALL_BIN) ./files/check_sanity $(1)/etc/crontabs/run.5/00-check_sanity
	$(INSTALL_BIN) ./files/check_wifi_channel $(1)/etc/crontabs/run.5/01-check_wifi_channel
	$(INSTALL_BIN) ./files/check_dns $(1)/etc/crontabs/run.5/02-check_dns

	# Modules
	$(INSTALL_DIR) $(1)/etc/nodewatcher.d
	$(CP) ./files/watchdog.sh $(1)/etc/nodewatcher.d/watchdog.sh
endef

$(eval $(call BuildPackage,nodewatcher-watchdog))
