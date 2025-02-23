module("luci.controller.custom.authctrl", package.seeall)

function index()
    entry({"auth", "activate"}, call("activate"), _("Device Activation"), 1)
end

function activate()
    local http = require "luci.http"
    local fs = require "nixio.fs"
    local auth_file = "/etc/auth.info"

    -- 读取机器码和授权码
    local machine_code, auth_code = "N/A", "N/A"
    if fs.access(auth_file) then
        for line in io.lines(auth_file) do
            if line:match("MACHINE_CODE=") then
                machine_code = line:split("=")[2]
            elseif line:match("AUTH_CODE=") then
                auth_code = line:split("=")[2]
            end
        end
    end

    -- 处理表单提交
    if http.formvalue("authcode") then
        local input_code = http.formvalue("authcode"):upper():gsub("%s+", "")
        if input_code == auth_code then
            fs.remove("/etc/firstboot")
            fs.writefile("/etc/auth.lock", "1")
            http.redirect(luci.dispatcher.build_url("admin"))
        else
            http.redirect(luci.dispatcher.build_url("auth/activate?error=1"))
        end
    else
        luci.template.render("custom/activate", {
            error = http.getenv("QUERY_STRING"):match("error=1"),
            machine_code = machine_code
        })
    end
end