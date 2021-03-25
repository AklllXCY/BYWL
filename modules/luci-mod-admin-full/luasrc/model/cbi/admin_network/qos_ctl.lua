require("luci.sys")
require("luci.sys.zoneinfo")
require("luci.tools.webadmin")
local fs=require("nixio.fs")
require("luci.config")

local m,s,o
m = Map("tastek", translate("网速控制"), translate("对某些IP进行网速控制"))
m:chain("luci")
--m.pageaction = false

s = m:section(TypedSection,"qos_ctl",nil)
s.anonymous = true
s.addremove = false

s:tab("qos", translate("网速限制设置"))
o=s:taboption("qos",ListValue, "qos_en_m", "网速限制总开关")
o.datatype = "uinteger"
o:value(0, translate("不开启"))
o:value(1, translate("开启"))

o=s:taboption("qos",Value, "qos_up_speed", "最大上行速度（Mbps）")
o:depends("qos_en_m",1)

o=s:taboption("qos",Value, "qos_down_speed", "最大下行速度（Mbps）")
o:depends("qos_en_m",1)

for i=1,5,1 do

	s:tab("qos"..i, translate("网速限制组"..i))
	o=s:taboption("qos"..i,ListValue, "qos_en"..i, "网速限制开关")
	o.datatype = "uinteger"
	o:value(0, translate("不开启"))
	o:value(1, translate("开启"))
	
	o=s:taboption("qos"..i,Value, "qos_ip_s"..i, "网速控制开始IP")
	o:depends("qos_en"..i,1)
	
	o=s:taboption("qos"..i,Value, "qos_ip_e"..i, "网速控制结束IP")
	o:depends("qos_en"..i,1)
	
end
apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("qos_ctl.sh")
end

return m
