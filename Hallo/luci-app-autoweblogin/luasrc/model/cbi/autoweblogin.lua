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

o2 = e:option(ListValue, "type", translate("选择模式"))
o2:value("0", "未选取")
o2:value("http://172.16.253.121/quickauth.do?userid=$1&passwd=$2&wlanuserip=$3&wlanacname=NFV-BASE-SGYD2&wlanacIp=172.16.253.114&ssid=&vlan=1116&mac=a1%3Ab2%3Ac3%3Ad4%3Ae5%3Af6&version=0&portalpageid=1&timestamp=1729679857228&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2&sendFttrNotice=0", "韶关学院")
o2:value("http://172.16.13.10:6060/quickauth.do?userid=$1&passwd=$2&wlanuserip=$3&wlanacname=NFV-BASE&wlanacIp=172.16.13.11&ssid=&vlan=24012633&mac=a1%3Ab2%3Ac3%3Ad4%3Ae5%3Af6&version=0&portalpageid=2&validateCode=&timestamp=1729925521855&portaltype=0&hostname=HuaWei&bindCtrlId=&validateType=0&bindOperatorType=2", "沈阳科技")
o2.default = "0"

o3 = e:option(Value, "user_account", translate("账号"))

o4 = e:option(Value, "user_password", translate("密码"))
o4.password = true

o5 = e:option(ListValue, "interface", translate("选择获取IP的接口"), translate("根据实际情况选择外网接口，一般为eth1或wan"))
for t, e in ipairs(i.net.devices()) do
    if e ~= "lo" then o:value(e) end
end
o.rmempty = false

o6 = e:option(Value, "time", translate("网络检测间隔"), translate("以秒为单位"))

m:section(SimpleSection).template = "autoweblogin/autoweblogin_button"

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/autoweblogin start")
end

return m

