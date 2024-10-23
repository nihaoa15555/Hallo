include $(TOPDIR)/rules.mk

LUCI_TITLE:=shanligong web for luci
LUCI_PKGARCH:=all
PKG_VERSION:=2.5.0
PKG_RELEASE:=4
PKG_NAME:=luci-app-shanligong

define Package/luci-app-shanligong/install
	chmod +x $(1)/etc/init/*
endef

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,luci-app-shanligong))
