include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-defense
PKG_VERSION=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-defense
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-defense/description
	Configure defense on the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-defense/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/defense/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	
	$(INSTALL_BIN) ./controller/defense.lua $(1)/usr/lib/lua/luci/controller/defense.lua
	$(INSTALL_BIN) ./model/cbi/defense.lua $(1)/usr/lib/lua/luci/model/cbi/defense.lua
	$(INSTALL_DATA) ./view/defense/* $(1)/usr/lib/lua/luci/view/defense/
	$(INSTALL_CONF) ./etc/config/defense $(1)/etc/config/defense
	$(INSTALL_BIN) ./etc/init.d/defense $(1)/etc/init.d/defense
endef

$(eval $(call BuildPackage,luci-app-defense))