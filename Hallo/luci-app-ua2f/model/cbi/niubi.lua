m = Map("niubi", translate("防检测"))

m:section(SimpleSection).template = "niubi/niubi_A"

e = m:section(TypedSection, "niubi", translate("设置"))
e.addremove = false
e.anonymous = true

o1 = e:option(ListValue, "enabled", translate("启用/开机自启"))
o1:value("1", "启用")
o1:value("0", "禁用")
o1.default = "0"

o2 = e:option(Value, "Custom_UA", translate("UA"), translate("自定义UA"))
o2.default = "Mozilla/5.0 (Window NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/555.66"

m.on_commit = function(self)
    luci.sys.call("/etc/init.d/niubi start")
end

return m
