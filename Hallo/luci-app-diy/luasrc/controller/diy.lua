module("luci.controller.diy", package.seeall)

function index()
    entry({"admin", "school"}, alias("admin", "school", "htm"), _("基础设置"),1)
    entry({"admin", "school", "htm"}, cbi("mlgb"), _("路由情况"), 1)
    entry({"admin", "school", "WiFi"}, cbi("WiFi"), "WIFI设置", 2)
    entry({"admin", "school", "lanipc"}, cbi("lanip"), _("修改IP"), 5)
    entry({"admin", "school", "autoreboot"}, cbi("autoreboot"), _("定时重启"), 100)
end

