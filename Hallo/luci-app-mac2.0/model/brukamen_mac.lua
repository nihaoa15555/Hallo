local i = require "luci.sys"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local m, e

m = Map("brukamen_mac", translate("MAC克隆"), translate("MAC通常用于特定的上网环境，可以模拟特定设备与上游设设备通讯"))


e = m:section(TypedSection, "brukamen_mac")
e.addremove = false
e.anonymous = true

o = e:option(Flag, "enable", translate("启用"))
o.rmempty = false

o = e:option(Flag, "random", translate("开机时使用随机MAC"))
o.default = "0"
o.rmempty = false

o = e:option(Value, "interface", translate("选择接口"), translate("确保选择正确的 有线/无线 接口，修改一些特殊的接口可能导致宕机！！"))
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
o.default = "00:aa:bb:cc:dd:ee"
o.rmempty = false

m.on_commit = function(self)
    sys.call("/etc/init.d/brukamen_mac start")
    luci.http.redirect(luci.dispatcher.build_url("admin", "school", "brukamen_mac"))
end

return m

