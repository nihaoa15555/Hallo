include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-diy
PKG_VERSION=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-diy
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-diy/description
	Configure diy on the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-diy/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/diy/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	
	$(INSTALL_BIN) ./controller/diy.lua $(1)/usr/lib/lua/luci/controller/diy.lua
	$(INSTALL_BIN) ./model/cbi/* $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DATA) ./view/overview_status/* $(1)/usr/lib/lua/luci/view/overview_status/
	$(INSTALL_CONF) ./etc/config/* $(1)/etc/config/
	$(INSTALL_BIN) ./etc/init.d/autoreboot $(1)/etc/init.d/autoreboot
endef

$(eval $(call BuildPackage,luci-app-diy))
