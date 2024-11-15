m = Map("autoua2f", translate("防检测配置"))
m.description = translate([[
        <span style="font-family: '微软雅黑'; color: black">有网络的情况时下方会显示你的UA若为两个同的即为成功</span>
    ]])
    
m:section(SimpleSection).template = "ua2f/ua2f"
m:section(SimpleSection).template = "ua2f/ua2f_A"

e = m:section(TypedSection, "autoua2f", translate("UA检测"))
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


o3 = e:option(ListValue, "handle_intranet", translate("处理内网流量"), translate("修改内网的数据包"))
o3:value("1", "启用")
o3:value("0", "禁用")
o3.default = "1"

o4 = e:option(ListValue, "handle_tls", translate("IPID设置"), translate("修改IPID设置"))
o4:value("1", "启用")
o4:value("0", "禁用")
o4.default = "0"

o5 = e:option(ListValue, "handle_mmtls", translate("处理微信流量"), translate("一般无需处理"))
o5:value("1", "启用")
o5:value("0", "禁用")
o5.default = "0"

o6 = e:option(Value, "Custom_UA", translate("自定义用户代理"), translate("自定义UA设置"))
o6.default = "Mozilla/5.0 (Window NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/555.66"

m.on_commit = function(self)
    luci.sys.call("/etc/init.d/autoua2f start")
end

return m
