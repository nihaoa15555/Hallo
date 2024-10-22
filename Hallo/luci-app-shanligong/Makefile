#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=shanligong web for luci
LUCI_DEPENDS:=
LUCI_PKGARCH:=all
PKG_VERSION:=2.5.0
PKG_RELEASE:=4

define Package/luci-app-school/install
	chmod +x $(1)/etc/init/*
endef

$(eval $(call BuildPackage,luci-app-shanligong))
