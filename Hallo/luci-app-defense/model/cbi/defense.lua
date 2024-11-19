m = Map("defense", translate("防检测配置"))
m.description = translate([[
        <span style="font-family: '微软雅黑'; color: black">显示两个不同的UA即为成功</span>
    ]])
    
m:section(SimpleSection).template = "defense/defense"
m:section(SimpleSection).template = "defense/defense_A"

e = m:section(TypedSection, "defense", translate("检测设置"))
e.addremove = false
e.anonymous = true

o1 = e:option(ListValue, "enabled", translate("开启UA设置"), translate("修改UA字符"))
o1:value("1", "启用")
o1:value("0", "禁用")
o1.default = "0"

o2 = e:option(ListValue, "handle_fw", translate("开启IPID修改"), translate("IPID修改"))
o2:value("1", "启用")
o2:value("0", "禁用")
o2.default = "0"

o3 = e:option(ListValue, "handle_intranet", translate("开启统一时钟偏移"), translate("统一时钟偏移"))
o3:value("1", "启用")
o3:value("0", "禁用")
o3.default = "0"


o6 = e:option(Value, "Custom_UA", translate("修改UA"), translate("自定义UA设置"))
o6.default = "Mozilla/5.0 (Window NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/555.66"

m.on_commit = function(self)
    luci.sys.call("/etc/init.d/defense start")
end

return m
