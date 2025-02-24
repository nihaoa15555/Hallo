include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-autoweblogin
PKG_VERSION=1.1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-autoweblogin
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-autoweblogin/description
	Configure autoweblogin on the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-autoweblogin/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/autoweblogin/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/usr/bin/autoweblogin
	
	$(INSTALL_BIN) ./controller/autoweblogin.lua $(1)/usr/lib/lua/luci/controller/autoweblogin.lua
	$(INSTALL_BIN) ./model/cbi/autoweblogin.lua $(1)/usr/lib/lua/luci/model/cbi/autoweblogin.lua
	$(INSTALL_BIN) ./model/cbi/autoweblogin_log.lua $(1)/usr/lib/lua/luci/model/cbi/autoweblogin_log.lua
	$(INSTALL_DATA) ./view/autoweblogin/* $(1)/usr/lib/lua/luci/view/autoweblogin/
	$(INSTALL_CONF) ./etc/config/autoweblogin $(1)/etc/config/autoweblogin
	$(INSTALL_BIN) ./etc/init.d/autoweblogin $(1)/etc/init.d/autoweblogin
	$(INSTALL_BIN) ./autoweblogin.sh $(1)/usr/bin/autoweblogin.sh
endef

$(eval $(call BuildPackage,luci-app-autoweblogin))
