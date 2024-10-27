a = Map("mia")
a.title = translate("Internet Access Schedule Control")
a.description = translate("Access Schedule Control Settins")

a:section(SimpleSection).template  = "mia/mia_status"

t = a:section(TypedSection, "basic")
t.anonymous = true

e = t:option(ListValue, "enable", translate("是否开启"))
e:value("1", "启用")
e:value("0", "禁用")
e.default = "0"

e = t:option(ListValue, "strict", translate("Strict Mode"))
e:value("1", "启用")
e:value("0", "禁用")
e.default = "0"
e.description = translate("Strict Mode will degrade CPU performance, but it can achieve better results")

t = a:section(TypedSection, "macbind", translate("Client Rules"))
t.template = "cbi/tblsection"
t.anonymous = true
t.addremove = true

e = t:option(Flag, "enable", translate("Enabled"))
e.rmempty = false
e.default = "1"

e = t:option(Value, "macaddr", translate("MAC address (Computer Name)"))
e.rmempty = true
luci.sys.net.mac_hints(function(t,a)
e:value(t,"%s (%s)"%{t,a})
end)

e = t:option(Value, "timeon", translate("Start time"))
e.optional = false
e.default = "00:00"

e = t:option(Value, "timeoff", translate("End time"))
e.optional = false
e.default = "23:59"

e = t:option(Flag, "z1", translate("Mon"))
e.rmempty = true
e.default = 1

e = t:option(Flag, "z2", translate("Tue"))
e.rmempty = true
e.default = 1

e = t:option(Flag, "z3", translate("Wed"))
e.rmempty = true
e.default = 1

e = t:option(Flag, "z4", translate("Thu"))
e.rmempty = true
e.default = 1

e = t:option(Flag, "z5", translate("Fri"))
e.rmempty = true
e.default = 1

e = t:option(Flag, "z6", translate("Sat"))
e.rmempty = true
e.default = 1

e = t:option(Flag, "z7", translate("Sun"))
e.rmempty = true
e.default = 1

return a
