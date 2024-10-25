m = Map("network", translate("修改Lan口IP"), translate("当路由器IP与上级路由器IP重复时请修改lan口IP以解决冲突问题"))
s = m:section(TypedSection, "interface",translate(""))
s.anonymous = true
function s:filter(value)
   return value == "lan" and value
end

g = s:option(Value, "ipaddr",translate("IP"), translate("输入类似192.168.2.1等适合的局域网IP"))
g.datatype = "ip4addr"

local apply=luci.http.formvalue("cbi.apply")
if apply then
    luci.util.exec("/etc/init.d/network restart &")
    luci.util.exec("ifdown wan && ifup wan")
end

return m