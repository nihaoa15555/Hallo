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

o6 = e:option(ListValue, "mode", translate("模式选择"))  
o6:value("mode0", "未选择")  
o6:value("mode1", "模式1")  
o6:value("mode2", "模式2")  
o6.default = "mode0"  

o2 = e:option(Value, "user_account", translate("账号"))  

o3 = e:option(Value, "user_password", translate("密码"))  
o3.password = true  

o = e:option(ListValue, "interface", translate("选择获取IP的接口"), translate("根据实际情况选择外网接口，一般为eth1或wan"))  
for t, e in ipairs(i.net.devices()) do  
    if e ~= "lo" then o:value(e) end  
end  
o.rmempty = false  

o5 = e:option(Value, "time", translate("网络检测间隔"), translate("以秒为单位"))  

m:section(SimpleSection).template = "autoweblogin/autoweblogin_button"  

-- 处理表单提交  
local apply = luci.http.formvalue("cbi.apply")  
if apply then  
    local mode = luci.http.formvalue("mode")  
    if mode == "mode0" then  
        luci.http.redirect(luci.dispatcher.build_url("your/error/page"))  -- 重定向到错误页面  
        return  
    end  
    local user_account = luci.http.formvalue("user_account")  
    local user_password = luci.http.formvalue("user_password")  
    
    -- 调用脚本，并将参数传递给它  
    os.execute(string.format("/path/to/your/script.sh %s %s %s", mode, user_account, user_password))  

    -- 启动服务  
    io.popen("/etc/init.d/autoweblogin start")  
end  

return m
