include $(TOPDIR)/rules.mk

PKG_NAME:=nodewatcher-core
PKG_VERSION:=0.3
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/nodewatcher-core
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+busybox +cronscripts
  TITLE:=nodewatcher-core
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/nodewatcher-core/install
	# Base files
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_BIN) ./files/nodewatcher $(1)/www/cgi-bin
	$(INSTALL_BIN) ./files/opkgwatcher $(1)/www/cgi-bin

	# Sanity checks
	$(INSTALL_DIR) $(1)/etc/crontabs/run.5
	$(INSTALL_BIN) ./files/count_wifi_errors $(1)/etc/crontabs/run.5/03-count_wifi_errors
	
	# Common functions
	$(INSTALL_DIR) $(1)/lib/nodewatcher
	$(CP) ./files/nodewatcher_common.sh $(1)/lib/nodewatcher/common.sh
	
	# Modules
	$(INSTALL_DIR) $(1)/etc/nodewatcher.d
	$(CP) ./files/modules/general.sh $(1)/etc/nodewatcher.d/general.sh
	$(CP) ./files/modules/wireless.sh $(1)/etc/nodewatcher.d/wireless.sh
	$(CP) ./files/modules/vpn.sh $(1)/etc/nodewatcher.d/vpn.sh
	$(CP) ./files/modules/traffic.sh $(1)/etc/nodewatcher.d/traffic.sh
endef

$(eval $(call BuildPackage,nodewatcher-core))
