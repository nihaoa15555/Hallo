module("luci.controller.NetTask", package.seeall)

function index()
	entry({"admin", "services", "NetTask"},alias("admin", "services", "NetTask","commonly"), _("校园网自动登入"))
	entry({"admin", "services", "NetTask", "commonly"},cbi("nettask"), _("基本功能"), 10).leaf = true
	entry({"admin", "services", "NetTask", "trontabs"}, cbi("trontabs"), _("高级功能"), 20).leaf = true
end
