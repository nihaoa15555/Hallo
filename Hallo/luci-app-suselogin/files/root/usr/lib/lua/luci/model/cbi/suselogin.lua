-- Copyright 2020 BlackYau <blackyau426@gmail.com>
-- GNU General Public License v3.0


require("luci.sys")

m = Map("suselogin", translate("校园网认证"), translate("自动连接网络,支持断线自动重连"))

s = m:section(TypedSection, "login", "")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enable", translate("启用"), translate("启用后即会检测上网状态，并尝试自动拨号"))
enable.rmempty = false

name = s:option(Value, "username", translate("用户名(学号)"))
name.rmempty = false
pass = s:option(Value, "password", translate("密码(电话号)"))
pass.password = true
pass.rmempty = false

o = e:option(Value, "interface", translate("选择获取IP的接口"), translate("根据实际情况选择外网接口，一般为eth1或wan"))
for t, e in ipairs(i.net.devices()) do
    if e ~= "lo" then o:value(e) end
end
o.rmempty = false

interval = s:option(Value, "interval", translate("间隔时间"), translate("每隔多少时间(≥1)检测一下网络是否连接正常，如果网络异常则会尝试连接(单位:分钟)"))
interval.default = 5
interval.datatype = "min(1)"


local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/suselogin restart")
end

return m
