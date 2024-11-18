include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-weblogin
PKG_VERSION=2.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-weblogin
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-weblogin/description
	Edit the shell script in the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-weblogin/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/cbi/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/weblogin/filetab/
	
	$(INSTALL_BIN) ./controller/* $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_BIN) ./model/* $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_BIN) ./view/* $(1)/usr/lib/lua/luci/view/cbi/
	$(INSTALL_CONF) ./etc/config/weblogin $(1)/etc/config/weblogin
	$(INSTALL_BIN) ./etc/init.d/weblogin $(1)/etc/init.d/weblogin
	$(INSTALL_DATA) ./etc/weblogin/* $(1)/etc/weblogin/
	chmod +x $(1)/etc/weblogin/*
endef

$(eval $(call BuildPackage,luci-app-weblogin))
