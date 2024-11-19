module("luci.controller.defense", package.seeall)

function index()
    entry({"admin", "school"}, alias("admin", "school", "htm"), _("防检测"),2)
    entry({"admin", "school", "defense"}, cbi("defense"), _("防检测设置"), 94).leaf = true
end


