module("luci.controller.MAC_clone", package.seeall)

function index()
    entry({"admin", "school", "MAC_clone"}, cbi("MAC_clone"), _("MAC克隆"), 10).leaf = true
end
