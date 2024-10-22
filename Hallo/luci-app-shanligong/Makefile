include $(TOPDIR)/rules.mk

LUCI_TITLE:=shanligong web for luci
LUCI_DEPENDS:=
LUCI_PKGARCH:=all
PKG_VERSION:=2.5.0
PKG_RELEASE:=4

define Package/luci-app-school/postinst
	chmod +x $(1)/etc/init/*
endef

$(eval $(call BuildPackage,luci-app-shanligong))
