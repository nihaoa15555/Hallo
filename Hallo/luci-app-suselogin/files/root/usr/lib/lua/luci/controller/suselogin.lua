-- Copyright 2020 BlackYau <blackyau426@gmail.com>
-- GNU General Public License v3.0


module("luci.controller.suselogin", package.seeall)

function index()
        entry({"admin", "auto"}, alias("admin", "auto", "htm"), _("网页认证"),3)
        entry({"admin", "auto", "suselogin"},firstchild(), _("校园网认证认证"), 100).dependent = false
        entry({"admin", "auto", "suselogin", "general"}, cbi("suselogin"), _("配置"), 1)
        entry({"admin", "auto", "suselogin", "log"}, form("suseloginlog"), _("运行日志"), 2)
end
