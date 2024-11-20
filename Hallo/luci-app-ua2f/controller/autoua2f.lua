module("luci.controller.autoua2f", package.seeall)

function index()
    entry({"admin", "school"}, alias("admin", "school", "htm"), _("防检测配置"),2)
    entry({"admin", "school", "autoua2f"}, cbi("autoua2f"), _("防检测"), 94).leaf = true
end


