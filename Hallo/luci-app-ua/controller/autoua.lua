module("luci.controller.autoua", package.seeall)

function index()
    entry({"admin", "services", "autoua"}, cbi("autoua"), _("防检测设置"), 94)
    entry({"admin", "services", "autoua", "status"}, call("act_status")).leaf = true

end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep ua >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end


