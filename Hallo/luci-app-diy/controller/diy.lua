module("luci.controller.diy", package.seeall)

function index()
    entry({"admin", "diy"}, alias("admin", "diy", "htm"), _("基础设置"),1)
    entry({"admin", "diy", "htm"}, cbi("mlgb"), _("路由状态"), 1)
    entry({"admin", "diy", "WiFi"}, cbi("WiFi"), "WIFI设置", 2)
    entry({"admin", "diy", "lanipc"}, cbi("lanip"), _("修改IP"), 5)
    entry({"admin", "diy", "autoreboot"}, cbi("autoreboot"), _("定时重启"), 100)
end

