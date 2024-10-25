include $(TOPDIR)/rules.mk

LUCI_TITLE:=Luci for School Bypass
LUCI_DEPENDS:=+kmod-rkp-ipid +ua2f
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-school

define Package/luci-app-school/install
	chmod 755 /etc/init.d/*
endef

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,luci-app-school))
