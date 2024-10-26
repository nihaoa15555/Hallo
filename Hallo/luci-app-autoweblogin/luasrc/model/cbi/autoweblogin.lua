local i = require "luci.sys"

m = Map("autoweblogin", translate("校园网认证"))
m:section(SimpleSection).template = "autoweblogin/autoweblogin"

e = m:section(TypedSection, "BBBZZB", translate(""))
e.addremove = false
e.anonymous = true

o1 = e:option(value, "enabled", translate("启用/开机自启"))
o1:value("0", "启用")
o1:value("1", "禁用")
o1.default = "1"

o2 = e:option(Value, "user_account", translate("账号"))

o3 = e:option(Value, "user_password", translate("密码"))
o3.password = true

o = e:option(Value, "interface", translate("选择获取IP的接口"), translate("根据实际情况选择外网接口，一般为eth0.1或wan"))
for t, e in ipairs(i.net.devices()) do
    if e ~= "lo" then o:value(e) end
end
o.rmempty = false

o5 = e:option(Value, "time", translate("网络检测间隔"), translate("以秒为单位"))

m:section(SimpleSection).template = "autoweblogin/autoweblogin_button"

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/autoweblogin start")
end

return m

