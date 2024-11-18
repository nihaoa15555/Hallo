module("luci.controller.weblogin", package.seeall)

function index()
    entry({"admin", "auto"}, alias("admin", "auto", "htm"), _("网页认证"),3)
    entry({"admin", "auto", "weblogin"}, alias("admin", "auto", "weblogin", "post"), _("校园网认证"), 99).index = true
    entry({"admin", "auto", "weblogin", "post"}, cbi("weblogin"), _("认证设置"), 1)
    entry({"admin", "auto", "weblogin", "log"}, cbi("weblogin_log"), _("认证日志"), 2)
    entry({"admin", "auto", "weblogin", "status"}, call("act_status")).leaf = true

end

function act_status()
	local e = {}
	e.running = luci.sys.call("ps | grep weblogin | grep -v grep >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

