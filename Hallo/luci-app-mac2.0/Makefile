include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-mac.2.0
PKG_VERSION=2.2.2
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-mac.2.0
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-mac.2.0/description
	Edit the shell script in the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-mac.2.0/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/cbi/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	
	$(INSTALL_BIN) ./controller/* $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_BIN) ./model/* $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_BIN) ./view/* $(1)/usr/lib/lua/luci/view/cbi/
	$(INSTALL_CONF) ./etc/config/* $(1)/etc/config/mac.2.0
	$(INSTALL_BIN) ./etc/init.d/* $(1)/etc/init.d/mac.2.0
	$(INSTALL_DATA) ./etc/init.d/* $(1)/etc/init.d/
	chmod +x $(1)/etc/init/*
endef

$(eval $(call BuildPackage,luci-app-mac.2.0))
