include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-mac
PKG_VERSION=1.1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-mac
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-mac/description
	Configure mac on the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-mac/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	
	$(INSTALL_BIN) ./controller/MAC_clone.lua $(1)/usr/lib/lua/luci/controller/MAC_clone.lua
	$(INSTALL_BIN) ./model/cbi/MAC_clone.lua $(1)/usr/lib/lua/luci/model/cbi/MAC_clone.lua
	$(INSTALL_CONF) ./etc/config/MAC_clone $(1)/etc/config/MAC_clone
	$(INSTALL_BIN) ./etc/init.d/MAC_clone $(1)/etc/init.d/MAC_clone
endef

$(eval $(call BuildPackage,luci-app-mac))
