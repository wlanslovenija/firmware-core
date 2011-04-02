include $(TOPDIR)/rules.mk

PKG_NAME:=nodewatcher-digitemp
PKG_VERSION:=0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/nodewatcher-digitemp
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+nodewatcher-core +digitemp
  TITLE:=nodewatcher-digitemp
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/nodewatcher-digitemp/install
	# Modules
	$(INSTALL_DIR) $(1)/etc/nodewatcher.d
	$(CP) ./files/digitemp.sh $(1)/etc/nodewatcher.d/digitemp.sh
endef

$(eval $(call BuildPackage,nodewatcher-digitemp))
