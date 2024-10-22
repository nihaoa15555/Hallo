include $(TOPDIR)/rules.mk

LUCI_TITLE:=Luci for School Bypass
LUCI_DEPENDS:=+kmod-rkp-ipid +ua2f
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-school
PKG_VERSION:=1
PKG_RELEASE:=10

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
define Package/luci-app-school/install
    $(INSTALL_DIR) $(1)/etc/init.d  
    $(INSTALL_DATA) ./root/etc/init.d/school $(1)/etc/init.d/school  
    $(CHMOD) 0755 $(1)/etc/init.d/school  
endef
