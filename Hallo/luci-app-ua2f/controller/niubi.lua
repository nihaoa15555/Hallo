module("luci.controller.niubi", package.seeall)

function index()
    entry({"admin", "school"}, alias("admin", "school", "htm"), _("校园网"),2)
    entry({"admin", "school", "niubi"}, cbi("niubi"), _("防检测"), 40).leaf = true
end





