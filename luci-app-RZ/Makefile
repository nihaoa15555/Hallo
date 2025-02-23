include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-RZ
PKG_VERSION=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-RZ
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-RZ/description
	Configure RZ on the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-RZ/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/RZ/
	$(INSTALL_DIR) $(1)/etc/init.d/
	
	$(INSTALL_BIN) ./controller/authctrl.lua $(1)/usr/lib/lua/luci/controller/authctrl.lua
	$(INSTALL_DATA) ./view/RZ/* $(1)/usr/lib/lua/luci/view/RZ/
	$(INSTALL_BIN) ./etc/init.d/generate_auth $(1)/etc/init.d/generate_auth
endef

$(eval $(call BuildPackage,luci-app-RZ))