--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]
acarsOnlineDataref=find_dataref("autoatc/acars/online")
acarsReceiveDataref=find_dataref("autoatc/acars/in")
sendDataref=find_dataref("autoatc/acars/out")
cduDataref=find_dataref("autoatc/cdu")

execLightDataref=find_dataref("sim/cockpit2/radios/indicators/fms_exec_light_copilot")
wasOnline=false
local lastSend=0
function getDefaultCycle()
  local file = io.open("Resources/default data/earth_nav.dat")
  if file==nil then
    return "2107" 
  end
  file:read("*l")
  local buildData=file:read("*l")
  io.close(file)
  return string.sub(buildData,27,30)
end
function getCycle()
  local file = io.open("Custom Data/earth_nav.dat", "r")
  if file==nil then
    return getDefaultCycle().." \n" 
  end
  file:read("*l")
  local buildData=file:read("*l")
  io.close(file)
  return string.sub(buildData,27,30).." \n"
end
autoATCState={}
autoATCState["initialised"]=false
autoATCState["online"]=false
acarsSystem.currentMessage={}
acarsSystem.getCurrentMessage=function(fmsID)
  return acarsSystem.currentMessage[fmsID]
end
--set the current message being viewed
acarsSystem.setCurrentMessage=function(fmsID,messageID)
  acarsSystem.currentMessage[fmsID]=messageID
end
acarsSystem.provider={
  messageID=1,
  logoff=function()
    if acarsSystem.provider.online()==true and fmsModules["data"]["atc"]~="****" then
      
      local tMSG={}
      tMSG["to"]=fmsModules["data"]["atc"]--getFMSData("acarsAddress")
      tMSG["type"]="cpdlc"
      tMSG["msg"]="LOGOFF"
      acarsSystem.provider.sendATC(json.encode(tMSG))
      autoATCState["online"]=false
    end
  end,
sendATC=function(value)
  print("LUA send ACARS message:"..value)
  local newMessage=json.decode(value)--check json value or fail
  newMessage["to"]=fmsModules["data"]["atc"]
  newMessage["from"]=getFMSData("fltno")
  newMessage["time"]=string.format("%02d:%02d",hh,mm)
  newMessage["messageID"]=acarsSystem.provider.messageID
  acarsSystem.provider.messageID=acarsSystem.provider.messageID+1
  --sendDataref=json.encode(newMessage)
  acarsSystem.messageSendQueue[table.getn(acarsSystem.messageSendQueue.values)+1]=json.encode(newMessage)
  --sleep(3)
end,
sendCompany=function(value)
  print("LUA send ACARS message:"..value)
  local newMessage=json.decode(value)--check json value or fail
  newMessage["to"]="company"
  newMessage["time"]=string.format("%02d:%02d",hh,mm)
  newMessage["messageID"]=acarsSystem.provider.messageID
  acarsSystem.provider.messageID=acarsSystem.provider.messageID+1
  --sendDataref=json.encode(newMessage)
  acarsSystem.messageSendQueue[table.getn(acarsSystem.messageSendQueue.values)+1]=json.encode(newMessage)
end,
send=function()
  local now=simDRTime
  local diff=simDRTime-lastSend
  if diff<15 then return end
  local queueSize=table.getn(acarsSystem.messageSendQueue.values)
  
  if queueSize>acarsSystem.sentMessage then
    local sending=acarsSystem.messageSendQueue[acarsSystem.sentMessage+1]
    print("LUA send ACARS send :"..sending)
    sendDataref=sending
    lastSend=simDRTime
    acarsSystem.sentMessage=acarsSystem.sentMessage+1
  end
end, 
receive=function() 
  updateAutoATCCDU()
  if string.len(acarsReceiveDataref)>1 then
    print("LUA ACARS receive message:".. acarsReceiveDataref)
    local newMessage=json.decode(acarsReceiveDataref)
    if newMessage["fp"] ~= nil then
      print("flight plan=" .. newMessage["fp"])
      file = io.open("Output/FMS plans/".. getFMSData("fltno") ..".fms", "w")
      io.output(file)
      io.write("I\n1100 Version\nCYCLE "..getCycle())
      io.write(newMessage["fp"])
      io.close(file)
      newMessage["fp"]= nil
    end

    if newMessage["initialised"]==true then
      autoATCState["initialised"]=true
    elseif newMessage["initialised"]==false then
      autoATCState["initialised"]=false
    end
    if newMessage["online"]==true then
      autoATCState["online"]=true
    elseif newMessage["online"]==false then
      autoATCState["online"]=false
    end
    if newMessage["type"]=="telex" then
      newMessage["read"]=false
      newMessage["time"]=string.format("%02d:%02d",hh,mm)
      newMessage["messageID"]=acarsSystem.provider.messageID
      acarsSystem.provider.messageID=acarsSystem.provider.messageID+1
      print("msg time "..newMessage["time"])
      acarsSystem.messages[table.getn(acarsSystem.messages.values)+1]=newMessage
    end
    if newMessage["type"]=="cpdlc" then
      newMessage["read"]=false
      if newMessage["msg"]=="LOGON ACCEPTED" or newMessage["msg"]=="SERVICE TERMINATED" then
        newMessage["read"]=true
      end
      newMessage["time"]=string.format("%02d:%02d",hh,mm)
      if newMessage["title"]==nil then
        newMessage["title"]=newMessage["from"].." "..string.sub(newMessage["msg"],1,15)
      end
      newMessage["messageID"]=acarsSystem.provider.messageID
      acarsSystem.provider.messageID=acarsSystem.provider.messageID+1
      acarsSystem.messages[table.getn(acarsSystem.messages.values)+1]=newMessage
    end
    acarsReceiveDataref=" "
    
    print("ACARS did receive message:"..acarsReceiveDataref)
  end  
end,

online=function()
  if acarsReceiveDataref==nil then return false end
  if wasOnline==true and acarsOnlineDataref==0 then
    wasOnline=false
    cduDataref="{}"
  end
  if acarsOnlineDataref==0 then return false end
  return true
end,

loggedOn=function()
  if autoATCState["initialised"]==false and autoATCState["online"]==false then
    return "   N/A "
  end
  if autoATCState["online"]==false then
    return "   N/A "
  end
  if fmsModules["data"]["atc"]~="****" then 
      return "ACCEPTED"
  else
    return "   READY"
  end
end
} 
local lastCDU={}

local lastSmallCDU={}
function readyCDU()
  
  wasOnline=true;
  return
end

function updateAutoATCCDU()
  
  if acarsSystem.provider.online()==false then return end
  
  if wasOnline==false then
    if is_timer_scheduled(readyCDU)==false then run_after_time(readyCDU,5) end
    cduDataref="{}"
    return
  end
  local thisID=fmsR.id
  for i=1,14,1 do
    lastCDU[i]=B747DR_fms[thisID][i]
    lastSmallCDU[i]=B747DR_fms_s[thisID][i]
  end
  local cdu={}
  cdu["small"]=lastSmallCDU
  cdu["large"]=lastCDU
  cdu["type"]="boeing"
  if(execLightDataref>0) then
    cdu["execLight"]="active"
  else
    cdu["execLight"]=""
  end
  cduDataref=json.encode(cdu)
end




