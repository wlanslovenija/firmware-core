include $(TOPDIR)/rules.mk

PKG_NAME:=nodeupgrade
PKG_VERSION:=0.4
PKG_RELEASE:=5

include $(INCLUDE_DIR)/package.mk

define Package/nodeupgrade
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+busybox
  TITLE:=NodeUpgrade
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/nodeupgrade/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) ./files/nodeupgrade $(1)/sbin
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/timeout $(1)/usr/bin
	$(INSTALL_DIR) $(1)/lib/upgrade
	$(CP) ./files/nodeupgrade.sh $(1)/lib/upgrade
	$(CP) ./files/base64.awk $(1)/lib/upgrade
	$(CP) ./files/hosts.awk $(1)/lib/upgrade
endef

$(eval $(call BuildPackage,nodeupgrade))
