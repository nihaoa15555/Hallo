module("luci.controller.diy", package.seeall)

function index()
    entry({"admin", "diy"}, alias("admin", "diy", "htm"), _("总览"),1)
    entry({"admin", "diy", "htm"}, cbi("world"), _("状态"), 1)
    entry({"admin", "diy", "WiFi"}, cbi("WiFi"), _("WIFI设置"), 2)
    entry({"admin", "diy", "lanipc"}, cbi("lanip"), _("后台地址"), 5)
end





