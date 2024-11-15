module("luci.controller.MAC_clone", package.seeall)

function index()
	entry({"admin", "school", "MAC_clone"},alias("admin", "school", "MAC_clone","commonly"), _("MAC克隆"))
	entry({"admin", "school", "MAC_clone", "commonly"},cbi("MAC_clone"), _("MAC设置"), 10).leaf = true
end
