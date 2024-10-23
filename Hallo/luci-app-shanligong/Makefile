#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=shanligong web for luci
LUCI_DEPENDS:=
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-shanligong

define Package/luci-app-shanligong/install
	chmod +x $(1)/etc/init/*
endef

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,luci-app-shanligong))
