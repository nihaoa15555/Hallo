module("luci.controller.autoweblogin", package.seeall)

function index()
    entry({"admin", "auto"}, alias("admin", "auto", "htm"), _("网页认证"),3)
    entry({"admin", "auto", "autoweblogin"}, alias("admin", "auto", "autoweblogin", "post"), _("校园网认证"), 99).index = true
    entry({"admin", "auto", "autoweblogin", "post"}, cbi("autoweblogin"), _("认证设置"), 1)
    entry({"admin", "auto", "autoweblogin", "log"}, cbi("autoweblogin_log"), _("认证日志"), 2)
    entry({"admin", "auto", "autoweblogin", "status"}, call("act_status")).leaf = true

end

function act_status()
	local e = {}
	e.running = luci.sys.call("ps | grep autoweblogin | grep -v grep >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

