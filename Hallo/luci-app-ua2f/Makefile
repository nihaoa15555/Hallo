include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ua2f
PKG_VERSION=1.8.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-ua2f
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	DEPENDS:=+ua2f
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-ua2f/description
	Configure UA2F on the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-ua2f/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/niubi/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	
	$(INSTALL_BIN) ./controller/niubi.lua $(1)/usr/lib/lua/luci/controller/niubi.lua
	$(INSTALL_BIN) ./model/cbi/niubi.lua $(1)/usr/lib/lua/luci/model/cbi/niubi.lua
	$(INSTALL_DATA) ./view/niubi/* $(1)/usr/lib/lua/luci/view/niubi/
	$(INSTALL_CONF) ./etc/config/niubi $(1)/etc/config/niubi
	$(INSTALL_BIN) ./etc/init.d/niubi $(1)/etc/init.d/niubi
endef

$(eval $(call BuildPackage,luci-app-ua2f))
