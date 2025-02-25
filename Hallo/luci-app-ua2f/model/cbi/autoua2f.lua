m = Map("autoua2f", translate("防检测"))

m:section(SimpleSection).template = "ua2f/ua2f_A"

e = m:section(TypedSection, "autoua2f", translate("设置"))
e.addremove = false
e.anonymous = true

o1 = e:option(ListValue, "enabled", translate("UA设置"), translate("修改UA字符"))
o1:value("1", "启用")
o1:value("0", "禁用")
o1.default = "0"

o2 = e:option(ListValue, "handle_fw", translate("TTL修改"), translate("默认设置为64"))
o2:value("1", "启用")
o2:value("0", "禁用")
o2.default = "1"


o3 = e:option(ListValue, "handle_intranet", translate("统一时钟偏移"), translate("统一时钟偏移"))
o3:value("1", "启用")
o3:value("0", "禁用")
o3.default = "1"

o4 = e:option(ListValue, "handle_tls", translate("IPID设置"), translate("修改IPID设置"))
o4:value("1", "启用")
o4:value("0", "禁用")
o4.default = "1"

o6 = e:option(Value, "Custom_UA", translate("修改UA"), translate("自定义UA设置"))
o6.default = "Mozilla/5.0 (Window NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/555.66"

m.on_commit = function(self)
    luci.sys.call("/etc/init.d/autoua2f start")
end

return m
