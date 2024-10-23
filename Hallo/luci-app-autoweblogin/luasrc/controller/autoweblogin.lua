module("luci.controller.autoweblogin", package.seeall)

function index()
    entry({"admin", "services", "autoweblogin"}, alias("admin", "services", "autoweblogin", "post"), _("网页认证"), 99).index = true
    entry({"admin", "services", "autoweblogin", "post"}, cbi("autoweblogin"), _("认证设置"), 1)
    entry({"admin", "services", "autoweblogin", "log"}, cbi("autologin_log"), _("认证日志"), 2)
    entry({"admin", "services", "autoweblogin", "status"}, call("act_status")).leaf = true

end

function act_status()
	local e = {}
	e.running = luci.sys.call("ps | grep autoweblogin | grep -v grep >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

