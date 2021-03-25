
module ("luci.message", package.seeall)

luci.sys.exec("stty -F /dev/ttyUSB1 raw speed 9600 -echo min 0 time 1")
wserial=io.open("/dev/ttyUSB1","w")
rserial=io.open("/dev/ttyUSB1","r")
wserial:flush()
rserial:read(1024)
wserial:write("at+cops?\r\n")
wserial:flush()
copschaine=rserial:read(1024)
wserial:write("at+csq\r\n")
wserial:flush()
csqchaine=rserial:read(1024)
wserial:write("at+cpin?\r\n")
wserial:flush()
sim=rserial:read(1024)
io.close(wserial)
io.close(rserial)

function dealcsq(data)
    if(data~=nil) then
        if(string.find(data,"+CSQ:") ~= nil) then
            if(string.find(data,"OK") ~= nil) then
                    return data;
                else
                    return "error";
                end
        else 
            return "error";
        end
    else
        return "error";
    end
end

function dealnettype(data)
    if(data~=nil) then
        if(string.find(data,"+COPS:") ~= nil and string.find(data,"OK") ~= nil) then
            i, j = data:find("+COPS:.-\r\n")
            if(tonumber(data:sub(i+6, j-2)) == 0) then
                return "error";
            else
                return string.split(data:sub(i+6, j-2), ',')[4];	
            end
        else
            return "error";
        end
    else
        return "error";
    end
end

function dealnetuser(data)
    if(data~=nil) then
        if(string.find(data,"+COPS:") ~= nil and string.find(data,"OK") ~= nil) then
            i, j = data:find("+COPS:.-\r\n")
            if(tonumber(data:sub(i+6, j-2)) == 0) then
                return "error";
            else
                return string.gsub(string.split(data:sub(i+6, j-2), ',')[3], "%p+", "");
            end
        else
            return "error";
        end
    else
        return "error";
    end
end

function dealcpin(data)
if(data~= nil) then
  return data
else
   return "error"
end
end

user = dealnetuser(copschaine)
type = dealnettype(copschaine)
csq = dealcsq(csqchaine)
cpin = dealcpin(sim)
