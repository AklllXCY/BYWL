require("luci.sys")
require("luci.sys.zoneinfo")
require("luci.tools.webadmin")
local fs=require("nixio.fs")
require("luci.config")

local m,s
m = Map("tastek", translate("APN参数配置"), translate("APN参数读取/修改"))
m:chain("luci")
--m.pageaction = false
s = m:section(TypedSection,"apn",nil)
s.anonymous = true
s.addremove = false
apn_id=s:option(Value, "apn_id", translate("PDP上下文ID(范围：0-11)"))
apn_type=s:option(ListValue, "apn_type", translate("APN接入点类型"))
apn_type:value(1, translate("IPv4"))
apn_type:value(2, translate("IPv6"))
apn_type:value(3, translate("IPv4v6"))
apn_name=s:option(Value, "apn_name", translate("APN接入点名称"))

apn_account=s:option(Value, "apn_account", translate("APN帐号"))
apn_password=s:option(Value, "apn_password", translate("APN密码"))
apn_auth=s:option(ListValue, "apn_auth", translate("APN加密方式"))
apn_auth.datatype = "uinteger"
apn_auth:value(0, translate("不启用加密"))
apn_auth:value(1, translate("Pap"))
apn_auth:value(2, translate("Chap"))
apn_auth:value(3, translate("MsChapV2"))
apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("lua /usr/sbin/apn.lua")
end

return m



