m = Map("school")
m.title = translate("Campus network detection bypass")
m.description = translate("Bypass campus network device detection")

m:section(SimpleSection).template  = "school/school"

s = m:section(TypedSection, "school")
s.addremove = false
s.anonymous = true

IPID = s:option(ListValue, "IPID", translate(" IPID 防检测 "))
IPID:value("1", "启用")
IPID:value("0", "禁用")
IPID.default = "0"
IPID.description = translate("iptables IPID 防检测")

IUA = s:option(ListValue, "IUA", translate(" HTTP-Headr 防检测 "))
IUA:value("1", "启用")
IUA:value("0", "禁用")
IUA.default = "0"
IUA.description = translate("修改 HTTP-Headr 防检测")

INTP = s:option(ListValue, "INTP", translate("修正 NTP 防检测 "))
INTP:value("1", "启用")
INTP:value("0", "禁用")
INTP.default = "0"
INTP.description = translate("修正 NTP 防检测")

ITTL = s:option(ListValue, "ITTL", translate(" 修改 TTL "))
ITTL:value("1", "启用")
ITTL:value("0", "禁用")
ITTL.default = "0"
ITTL.description = translate("iptables 修改 TTL 防检测")

IACFlash = s:option(ListValue, "IACFlash", translate(" 拒绝 AC 进行 Flash 检测 "))
IACFlash:value("1", "启用")
IACFlash:value("0", "禁用")
IACFlash.default = "0"
IACFlash.description = translate("iptables 拒绝 AC 进行 Flash 检测")

m.on_commit = function(self)
    luci.sys.call("/etc/init.d/school start")
end

return m
