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

include $(TOPDIR)/feeds/luci/luci.mk  

# Custom installation commands  
define Package/luci-app-shanligong/install
    $(INSTALL_DIR) $(1)/etc/init.d  
    $(INSTALL_DATA) ./root/etc/init.d/shanligong $(1)/etc/init.d/shanligong  
    $(CHMOD) 0755 $(1)/etc/init.d/shanligong  
endef

# call BuildPackage - OpenWrt buildroot signature
