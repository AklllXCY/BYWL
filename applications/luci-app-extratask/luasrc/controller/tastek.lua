module("luci.controller.tastek", package.seeall)

function index()
	entry({"admin", "network", "qos_ctl"}, cbi("qos_ctl"), _("网速控制"), 98)

    	entry({"admin", "network", "apn"}, cbi("apn"), _("APN设置"), 99)
end
