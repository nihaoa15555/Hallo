module("luci.controller.MAC", package.seeall)

function index()
    entry({"admin", "school", "MAC"}, cbi("MAC"), _("MAC克隆"), 90).leaf = true
end
