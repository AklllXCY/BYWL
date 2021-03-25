require("luci.sys")
function apnsetting()
	local type = luci.sys.exec("uci get tastek.apn.apn_type")
	if(#type == 0) then
		type = 0
	end
	local id= luci.sys.exec("uci get tastek.apn.apn_id")
	if(#id == 0) then
		id = 0
	end
	name = luci.sys.exec("uci get tastek.apn.apn_name")
	if(#name == 0) then
		name = ''
	else
		name = string.format("%s",name)
	end
	local account= luci.sys.exec("uci get tastek.apn.apn_account")
	if(#account == 0) then
		account = ''
	end
	local password = luci.sys.exec("uci get tastek.apn.apn_password")
	if(#password == 0) then
		password = ''
	else
		password = string.format("%s",password)
	end
	local auth = luci.sys.exec("uci get tastek.apn.apn_auth")
	if(#auth == 0) then
		auth = 0
	end

	data = string.format("at+qicsgp=%d,%d,%s,%s,%s,%d\r\n",tonumber(id),tonumber(type),tostring(name),tostring(account),tostring(password),tonumber(auth))
		
	luci.sys.exec("stty -F /dev/ttyUSB1 raw speed 9600 -echo min 0 time 1")
	wserial=io.open("/dev/ttyUSB1","w")
	rserial=io.open("/dev/ttyUSB1","r")
	wserial:flush()
	rserial:read(1024)
	wserial:write( data )
	wserial:flush()
	copschaine=rserial:read(1024)
	io.close(wserial)
	io.close(rserial)
	if(string.find(tostring(copschaine), "OK") ~= nil) then
		luci.sys.exec("uci set tastek.control.qos_en1=ok")
	else
		luci.sys.exec("uci set tastek.control.qos_en1=error")
	end
	luci.sys.exec("uci set tastek.control.qos_en2="..password)		
end		

		
	




