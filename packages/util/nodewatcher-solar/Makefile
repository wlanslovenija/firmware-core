include $(TOPDIR)/rules.mk

PKG_NAME:=nodewatcher-solar
PKG_VERSION:=0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/nodewatcher-solar
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+nodewatcher-core +solar +cronscripts
  TITLE:=nodewatcher-solar
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/nodewatcher-solar/install
	# Periodic measurements
	$(INSTALL_DIR) $(1)/etc/crontabs/run.30
	$(INSTALL_BIN) ./files/solar_measure $(1)/etc/crontabs/run.30/01-solar_measure

	# Modules
	$(INSTALL_DIR) $(1)/etc/nodewatcher.d
	$(CP) ./files/solar.sh $(1)/etc/nodewatcher.d/solar.sh
endef

$(eval $(call BuildPackage,nodewatcher-solar))
