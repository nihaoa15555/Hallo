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

o3 = e:option(Value, "user_account", translate("账号"))

o4 = e:option(Value, "user_password", translate("密码"))
o4.password = true

o5 = e:option(Value, "time", translate("网络检测间隔"), translate("以秒为单位"))


local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/autoweblogin start")
end

return m

