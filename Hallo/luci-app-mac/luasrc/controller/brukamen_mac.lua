module("luci.controller.brukamen_mac", package.seeall)

function index()
    entry({"admin", "service"}, alias("admin", "service", "htm"), _("校园网"),1)
    entry({"admin", "service", "htm"}, cbi("mlgb"), _("总览"), 1)
    entry({"admin", "service", "brukamen_mac"}, cbi("brukamen_mac"), _("MAC克隆"), 3)
    --entry({"admin", "service", "ua2f"}, cbi("ua2f"), "防检测配置", 4)
    entry({"admin", "service", "Brukamen_WiFi"}, cbi("Brukamen_WiFi"), "WIFI设置", 2)
    entry({"admin", "service", "lanipc"}, cbi("lanip"), _("修改IP"), 5)
    entry({"admin", "service", "autoreboot"}, cbi("autoreboot"), _("定时重启"), 100)
    --entry({"admin", "service", "CQR"}, cbi("donation"), _("支持我们"), 101)
end

