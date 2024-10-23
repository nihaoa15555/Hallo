f = SimpleForm("qrcode", translate(""))
f.reset = false
f.submit = false

f:section(SimpleSection).template  = "overview/overview_status"

return f
