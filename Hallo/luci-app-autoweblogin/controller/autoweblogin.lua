module("luci.controller.autoweblogin", package.seeall)

function index()
    entry({"admin", "auto"}, cbi("autoweblogin"), _("网页认证"), 3).index = true
    entry({"admin", "auto", "log"}, cbi("autoweblogin_log"), _("认证日志"), 1)
    entry({"admin", "auto", "status"}, call("act_status")).leaf = true
    entry({"admin", "auto", "autoweblogin", "status"}, call("act_status")).leaf = true

end




