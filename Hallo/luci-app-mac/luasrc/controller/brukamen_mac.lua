module("luci.controller.brukamen_mac", package.seeall)

function index()
    entry({"admin", "school"}, alias("admin", "school", "htm"), _("校园网"),1)
    entry({"admin", "school", "htm"}, cbi("mlgb"), _("路由器状态"), 1)
    entry({"admin", "school", "brukamen_mac"}, cbi("brukamen_mac"), _("MAC克隆"), 3)
    --entry({"admin", "school", "ua2f"}, cbi("ua2f"), "防检测配置", 4)
    entry({"admin", "school", "Brukamen_WiFi"}, cbi("Brukamen_WiFi"), "WIFI设置", 2)
    entry({"admin", "school", "lanipc"}, cbi("lanip"), _("修改IP"), 5)
    entry({"admin", "school", "autoreboot"}, cbi("autoreboot"), _("定时重启"), 100)
    --entry({"admin", "school", "CQR"}, cbi("donation"), _("支持我们"), 101)
end

