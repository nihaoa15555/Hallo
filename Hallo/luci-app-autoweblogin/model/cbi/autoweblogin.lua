local i = require "luci.sys"

m = Map("autoweblogin", translate("校园网认证"))
m:section(SimpleSection).template = "autoweblogin/autoweblogin"

e = m:section(TypedSection, "BBBZZB", translate(""))
e.addremove = false
e.anonymous = true

o1 = e:option(ListValue, "enabled", translate("启用/开机自启"))
o1:value("1", "启用")
o1:value("0", "禁用")
o1.default = "0"

o = e:option(ListValue, "mode", translate("模式选择"))
o:value("1", "韶关学院")
o:value("2", "沈阳科技")
o.default = "1"

o2 = e:option(Value, "user_account", translate("账号"))

o3 = e:option(Value, "user_password", translate("密码"))
o3.password = true

o = e:option(ListValue, "interface", translate("选择获取IP的接口"), translate("根据实际情况选择外网接口，一般为eth1或wan"))
for t, e in ipairs(i.net.devices()) do
    if e ~= "lo" then o:value(e) end
end
o.rmempty = false

o5 = e:option(Value, "time", translate("网络检测间隔"), translate("以秒为单位"))


local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/autoweblogin start")
end

return m

