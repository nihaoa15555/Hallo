local i = require "luci.sys"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local m, e

m = Map("MAC_clone", translate("MAC克隆"), translate("MAC通常用于特定的上网环境，可以模拟特定设备与上游设设备通讯"))


e = m:section(TypedSection, "MAC_clone")
e.addremove = false
e.anonymous = true

o1 = e:option(ListValue, "enable", translate("启用MAC克隆"))
o1:value("1", "启用")
o1:value("0", "禁用")
o1.default = "0"

o2 = e:option(ListValue, "random", translate("开机时使用随机MAC"))
o2:value("1", "启用")
o2:value("0", "禁用")
o2.default = "0"

o = e:option(ListValue, "interface", translate("选择接口"), translate("确保选择正确的 有线/无线 接口"))
for t, e in ipairs(i.net.devices()) do
    if e ~= "lo" then
        local mac_address = io.popen("ifconfig " .. e .. " | grep HWaddr | awk '{ print $5 }'")
        local mac = mac_address:read("*a")
        mac_address:close()
        o:value(e, e .. " - " .. mac)
    end
end
o.rmempty = false

function get_login_device_mac()
    local remote_ip = os.getenv("REMOTE_ADDR")
    if not remote_ip then
        return ""
    end

    local cmd = "ip neigh show | grep '" .. remote_ip .. "' | awk '{print $5}'"
    return luci.sys.exec(cmd):gsub("\n", ""):upper()
end

o = e:option(Value, "version", translate("手动修改mac"))
o.description = translate("当前设备（你的电脑）mac地址：" .. get_login_device_mac())
o.default = "a1:b2:c3:d4:e5:f6"
o.rmempty = false

m.on_commit = function(self)
    sys.call("/etc/init.d/MAC_clone start")
    luci.http.redirect(luci.dispatcher.build_url("admin", "school", "MAC_clone"))
end

return m

