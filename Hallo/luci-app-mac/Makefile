#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=mac for luci
LUCI_DEPENDS:=
LUCI_PKGARCH:=all
PKG_VERSION:=4.2.1
PKG_RELEASE:=4

define Package/luci-app-mac/install
	chmod 755 /etc/init.d/*
endef

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,luci-app-mac))
# call BuildPackage - OpenWrt buildroot signature
