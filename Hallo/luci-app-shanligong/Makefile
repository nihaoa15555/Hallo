include $(TOPDIR)/rules.mk

LUCI_TITLE:=shanligong web for luci
LUCI_PKGARCH:=all
PKG_VERSION:=2.5.0
PKG_RELEASE:=4
PKG_NAME:=luci-app-shanligong

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-shanligong/install
	chmod +x $(1)/etc/init/*
endef


$(eval $(call BuildPackage,luci-app-shanligong))
