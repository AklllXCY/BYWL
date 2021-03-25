module("luci.tools.apnsetting", package.seeall)

local type = luci.sys.exec("uci get tastek.apn.apn_type")
if(#type == 0) then
	type = ''
end
local id= luci.sys.exec("uci get tastek.apn.apn_id")
if(#id == 0) then
	id = ''
end
local name = luci.sys.exec("uci get tastek.apn.apn_name")
if(#name == 0) then
	name = ''
end
local account= luci.sys.exec("uci get tastek.apn.apn_account")
if(#account == 0) then
	account = ''
end
local password = luci.sys.exec("uci get tastek.apn.apn_password")
if(#password == 0) then
	password = ''
end
local auth = luci.sys.exec("uci get tastek.apn.apn_auth")
if(#auth == 0) then
	auth = ''
end
data = string.format("at+qicsgp=%d,%d,%s,%s,%s,%d\r\n",id,type,tostring(name),tostring(account),tostring(password),auth)
function deal()
	luci.sys.exec("stty -F /dev/ttyUSB2 raw speed 9600 -echo min 0 time 1")
	wserial=io.open("/dev/ttyUSB2","w")
	rserial=io.open("/dev/ttyUSB2","r")
	wserial:flush()
	rserial:read(1024)
	wserial:write(data)
	wserial:flush()
	copschaine=rserial:read(1024)
	if(string.find(copschaine, "ok") ~= nil) then
		luci.sys.exec("uci set tastek.control.qos_en1=666")
	else
		luci.sys.exec("uci set tastek.control.qos_en1=333")
	end
	io.close(wserial)
	io.close(rserial)
end