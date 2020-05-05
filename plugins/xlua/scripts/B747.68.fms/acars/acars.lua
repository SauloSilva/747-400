--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]

fmsPages["ACARS"]=createPage("ACARS")
fmsPages["ACARS"]["template"]={
"    ACARS-MAIN MENU     ",
"                        ",
"<PREFLIGHT         MSGS>",
"                        ",
"<INFLIGHT     VHF CNTRL>",
"                        ",
"<POSTFLIGHT     WXR REQ>",
"                        ",
"                        ",
"                        ",
"<MAINT EVENT      TIMES>",
"                        ",
"                        "
}
fmsFunctionsDefs["ACARS"]["L1"]={"setpage","PREFLIGHT"}
fmsFunctionsDefs["ACARS"]["R1"]={"setpage","ACARSMSGS"}

fmsPages["PREFLIGHT"]=createPage("PREFLIGHT")
fmsPages["PREFLIGHT"]["template"]={

"  ACARS-PREFLIGHT MENU  ",
"                        ",
"                        ",
"                        ",
"<INITIALIZE        MSGS>",
"                        ",
"              VHF CNTRL>",
"                        ",
"<UTC UPDATE     WXR REQ>",
string.format(" %02d:%02d:%02d               ",hh,mm,ss),
"            EVENT TIMES>", 
"                        ",
"                        ",
"<RETURN                 "
}

fmsFunctionsDefs["PREFLIGHT"]["L6"]={"setpage","ACARS"}
fmsFunctionsDefs["PREFLIGHT"]["R2"]={"setpage","ACARSMSGS"}

fmsPages["ACARSMSGS"]=createPage("ACARSMSGS")
fmsPages["ACARSMSGS"]["template"]={

"       ACARS-MSGS       ",
"                        ",
"                        ",
"                        ",
"<VIEW              SEND>",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ", 
"                        ",
"<RETURN                 "
}

fmsFunctionsDefs["ACARSMSGS"]["L6"]={"setpage","ACARS"} --go to last page or acars
fmsFunctionsDefs["ACARSMSGS"]["L2"]={"setpage","VIEWACARS"}
fmsFunctionsDefs["ACARSMSGS"]["R2"]={"acarsSystemSend",""}
fmsFunctionsDefs["ACARSMSGS"]["L6"]={"setpage","ACARS"}

fmsPages["VIEWACARS"]=createPage("VIEWACARS")

acarsSystem={}
acarsSystem.messages={{type="msg",msg="Test Message",title="Test Message",time="12:00 UTC",read=true},{type="msg",msg="2nd Test Message",title="Test Message",time="12:05 UTC",read=true}}
acarsReceiveDataref=find_dataref("autoatc/acars/in")
sendDataref=find_dataref("autoatc/acars/out")
sendCommand=find_command("AutoATC/ACARS")
acarsSystem.provider={
send=function(value)
  print("send ACARS message")
  sendDataref="ASL1012 good day"
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
end
}



function fmsFunctions.acarsSystemSend(fmsO,value) 
  acarsSystem.provider.send(value)
  fmsO["inCustomFMC"]=true
  fmsO["currentPage"]="ACARS" 
  local tMSG=json.encode({type="msg",msg="Test Message",time="12:00 UTC"})
  print(tMSG)
  local rMSG=json.decode(tMSG)
  print(rMSG["msg"])
  --print("setpage" .. value)
end



acarsSystem.getMessages=function()
    

     
    retVal={}
    retVal.template={
      "          MSGS          ",
      "                        ",
      "                        ", -- --"<Test Message           ",
      "                        ",
      "                        ", -- --"<2nd Test Message       ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "<RETURN                 "
      } 
    retVal.templateSmall={
      "                   1/1  ",
      "                        ",
      "                        ",
      "            12:00 UTC   ",
      "                        ",
      "            12:05 UTC   ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        "
      }
    line = 3  
    for i = #acarsSystem.messages,1 , -1 do
      retVal.template[line]="<"..acarsSystem.messages[i]["msg"]
      retVal.templateSmall[line+1]="            "..acarsSystem.messages[i]["time"]
      line = line+2
    end  
    return retVal
end

fmsPages["VIEWACARS"].getPage=function(self)
  
  
  local page=acarsSystem.getMessages()
  
  return page.template 
end

fmsPages["VIEWACARS"].getSmallPage=function(self) 
  local page=acarsSystem.getMessages()
  return page.templateSmall 
end
fmsFunctionsDefs["VIEWACARS"]["L6"]={"setpage","ACARS"}