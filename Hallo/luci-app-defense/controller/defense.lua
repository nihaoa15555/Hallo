module("luci.controller.defense", package.seeall)

function index()
    entry({"admin", "school"}, alias("admin", "school", "htm"), _("防检测"),2)
    entry({"admin", "school", "defense"}, cbi("defense"), _("防检测设置"), 94)
    entry({"admin", "school", "defense", "status"}, call("act_status")).leaf = true

end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep defense >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end


