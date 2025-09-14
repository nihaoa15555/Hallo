module("luci.controller.MAC", package.seeall)

function index()
    entry({"admin", "school", "MAC"}, cbi("MAC"), _("MAC克隆"), 10).leaf = true
end
