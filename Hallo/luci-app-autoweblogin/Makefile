#  
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>  
#  
# This is free software, licensed under the Apache License, Version 2.0 .  
#  

include $(TOPDIR)/rules.mk  

LUCI_TITLE:=autoweblogin web for luci  
LUCI_DEPENDS:=  
LUCI_PKGARCH:=all  

PKG_NAME:=luci-app-autoweblogin  
PKG_VERSION:=1  
PKG_RELEASE:=11  

define Package/luci-app-autoweblogin/install  
	$(INSTALL_DIR) $(1)/etc/init.d  
	$(INSTALL_BIN) ./root/etc/init.d/autoweblogin $(1)/etc/init.d/autoweblogin  
endef  

include $(TOPDIR)/feeds/luci/luci.mk  

$(eval $(call BuildPackage,luci-app-autoweblogin))
