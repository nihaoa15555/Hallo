include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-shanligong
PKG_VERSION=2.2.2
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-school
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=file transfer tool
	PKGARCH:=all
endef

define Package/luci-app-shanligong/description
	Edit the shell script in the web.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-shanligong/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/cbi/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/init.d/
	
	$(INSTALL_BIN) ./luasrc/controller/* $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_BIN) ./luasrc/model/cbi/* $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_BIN) ./luasrc/view/* $(1)/usr/lib/lua/luci/view/cbi/
	$(INSTALL_CONF) ./root/etc/config/shanligong $(1)/etc/config/shanligong
	$(INSTALL_BIN) ./root/etc/init.d/shanligong $(1)/etc/init.d/shanligong
	$(INSTALL_DATA) ./root/etc/init.d/* $(1)/etc/shanligong/
	chmod +x $(1)/etc/shanligong/*
endef

$(eval $(call BuildPackage,luci-app-shanligong))
