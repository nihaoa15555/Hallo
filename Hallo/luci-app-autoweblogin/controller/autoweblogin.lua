module("luci.controller.autoweblogin", package.seeall)

function index()
    entry({"admin", "auto"}, alias("admin", "auto", "htm"), _("网页认证"),3)
    entry({"admin", "auto", "autoweblogin"}, alias("admin", "auto", "autoweblogin", "post"), _("自动登入"), 99).index = true
    entry({"admin", "auto", "autoweblogin", "post"}, cbi("autoweblogin"), _("认证设置"), 1)
    entry({"admin", "auto", "autoweblogin", "log"}, cbi("autoweblogin_log"), _("认证日志"), 2)
    entry({"admin", "auto", "autoweblogin", "status"}, call("act_status")).leaf = true

end




