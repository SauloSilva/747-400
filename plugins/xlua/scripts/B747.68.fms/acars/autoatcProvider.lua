--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]
acarsOnlineDataref=find_dataref("autoatc/acars/online")
acarsReceiveDataref=find_dataref("autoatc/acars/in")
sendDataref=find_dataref("autoatc/acars/out")
sendCommand=find_command("AutoATC/ACARS")
acarsSystem.provider={
send=function(value)
  print("send ACARS message:"..value)
  sendDataref=value
  sendCommand:once()
end,
receive=function() 
  
  if string.len(acarsReceiveDataref)>1 then
    print("ACARS receive message:".. acarsReceiveDataref)
    local newMessage=json.decode(acarsReceiveDataref)
    newMessage["read"]=false
    newMessage["time"]=string.format("%02d:%02d",hh,mm)
    acarsReceiveDataref=" "
    acarsSystem.messages[#acarsSystem.messages+1]=newMessage
    print("ACARS did receive message:"..acarsReceiveDataref)
  end  
end,
online=function()
  if acarsReceiveDataref==nil then return false end
  if acarsOnlineDataref==0 then return false end
  return true
end
} 
