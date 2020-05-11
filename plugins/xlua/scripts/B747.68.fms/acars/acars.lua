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
fmsFunctionsDefs["PREFLIGHT"]["L2"]={"setpage","INITIALIZE"}
fmsFunctionsDefs["PREFLIGHT"]["R2"]={"setpage","ACARSMSGS"}
fmsPages["INITIALIZE"]=createPage("INITIALIZE")
fmsPages["INITIALIZE"].getPage=function(self,pgNo)--dynamic pages need to be this way
  fmsPages["INITIALIZE"]["template"]={

  "  ACARS-INITIALIZATION  ",
  "                        ",
  "<"..fmsModules["data"]["fltno"] .."        "..fmsModules.data["fltdate"],
  "                        ",
  "<".. fmsModules.data["fltdep"] .."/"..fmsModules.data["fltdst"] .."        "..fmsModules.data["flttimehh"] ..":"..fmsModules.data["flttimemm"] ..">",
  "                        ",
  fmsModules.data["rpttimehh"] ..":"..fmsModules.data["rpttimemm"] .."            ------>",
  "                        ",
  "<------          ------>",
  "F/O ID       CHK CAPT ID",
  "<------          ------>",
  "                        ",
  "<RETURN                 "
  }
  return fmsPages["INITIALIZE"]["template"]
end
fmsPages["INITIALIZE"]["templateSmall"]={
"                        ",
"FLT NO          UTC DATE",
"                        ",
"DEP/DES         FLT TIME",
"                        ",
"RPT TIME         S/01 ID",
"                        ",
"CAPT ID          S/02 ID",
"                        ",
"                        ",
"                        ",
"                        ", 
"                        ",
"                        "
}
fmsFunctionsDefs["INITIALIZE"]["L6"]={"setpage","PREFLIGHT"}
fmsFunctionsDefs["INITIALIZE"]["L1"]={"setdata","fltno"}
fmsFunctionsDefs["INITIALIZE"]["L2"]={"setdata","depdst"}
fmsFunctionsDefs["INITIALIZE"]["L3"]={"setdata","rpttime"}
fmsFunctionsDefs["INITIALIZE"]["R1"]={"setdata","fltdate"}
fmsFunctionsDefs["INITIALIZE"]["R2"]={"setdata","flttime"}
fmsPages["ACARSMSGS"]=createPage("ACARSMSGS")
fmsPages["ACARSMSGS"]["template"]={

"    ACARS-MSGS MENU     ",
"                        ",
"<FLT DSPTCH        MISC>",
"                        ",
"<UPLINK           DNLNK>",
"                        ",
"<PRINT UNDELIVERED MSGS ",
"                        ",
"                        ",
"                        ",
"                        ", 
"                        ",
"<RETURN                 "
}
fmsPages["ACARSMSGS"]["templateSmall"]={
"                        ",
"--------SEND MSG--------",
"                        ",
"-------STORED MSG-------",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ", 
"                        ",
"                        "
}
fmsFunctionsDefs["ACARSMSGS"]["L6"]={"setpage","ACARS"} --go to last page or acars
fmsFunctionsDefs["ACARSMSGS"]["R1"]={"setpage","VIEWMISCACARS"}

fmsFunctionsDefs["ACARSMSGS"]["L6"]={"setpage","ACARS"}

fmsPages["VIEWMISCACARS"]=createPage("VIEWMISCACARS")

acarsSystem={}
acarsSystem.messages={{type="msg",msg="Test Message",title="Test Message",time="12:00 UTC",read=true},{type="msg",msg="2nd Test Message",title="Test Message",time="12:05 UTC",read=true}}

dofile("acars/autoatcProvider.lua")

function fmsFunctions.acarsSystemSend(fmsO,value)
  if acarsSystem.provider.online() then
    local msgToSend=value
    if string.len(msgToSend) <5 then msgToSend=fmsO["scratchpad"] end
    if string.len(msgToSend) <5 then fmsO["notify"]="EMPTY MESSAGE" return end
    acarsSystem.provider.send(msgToSend)
    fmsO["inCustomFMC"]=true
    --fmsO["currentPage"]="ACARS" 
    local tMSG=json.encode({type="msg",msg="Test Message",time="12:00 UTC"})
    print(tMSG)
    local rMSG=json.decode(tMSG)
    print(rMSG["msg"])
  else
    fmsO["notify"]="ACARS NO COMM" 
  end
  --print("setpage" .. value)
end



acarsSystem.getMiscMessages=function(pgNo)
    

     
    retVal={}
    retVal.template={
      "    ACARS-MISC MSGS     ",
      "                        ",
      "                        ", -- --"<Test Message           ",
      "                        ",
      "                        ", -- --"<2nd Test Message       ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      " ADDRESS                ",
      "<"..fmsModules["data"]["acarsAddress"] .."           SEND>",
      "                        ",
      "<RETURN                 "
      } 
    retVal.templateSmall={
      "                    "..pgNo.."/"..math.ceil(#acarsSystem.messages/4).."  ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        ",
      "                        "
      }
    line = 3
    startNo=#acarsSystem.messages
    
    if pgNo>1 then startNo=#acarsSystem.messages-((pgNo-1)*4) end
    endNo=startNo-3
    if endNo <1 then endNo=1 end
    for i = startNo,endNo , -1 do
      retVal.template[line]="<"..acarsSystem.messages[i]["title"]
      if not acarsSystem.messages[i]["read"] then
	retVal.template[line]=retVal.template[line].." (new)"
      end
      retVal.templateSmall[line+1]="            "..acarsSystem.messages[i]["time"]
      fmsFunctionsDefs["VIEWMISCACARS"]["L"..(startNo-i+1)]={"showmessage",i}
      line = line+2
      
    end  
    return retVal
end

fmsPages["VIEWMISCACARS"].getPage=function(self,pgNo)
  local page=acarsSystem.getMiscMessages(pgNo)
  return page.template 
end
fmsPages["VIEWMISCACARS"].getSmallPage=function(self,pgNo) 
  local page=acarsSystem.getMiscMessages(pgNo)
  return page.templateSmall 
end
fmsPages["VIEWMISCACARS"].getNumPages=function(self)
  noPages=math.ceil(#acarsSystem.messages/4)
  return noPages 
end
fmsFunctionsDefs["VIEWMISCACARS"]["L5"]={"setdata","acarsAddress"}
fmsFunctionsDefs["VIEWMISCACARS"]["L6"]={"setpage","ACARSMSGS"}
fmsFunctionsDefs["VIEWMISCACARS"]["R5"]={"acarsSystemSend",""}

fmsPages["VIEWACARSMSG"]=createPage("VIEWACARSMSG")
fmsPages["VIEWACARSMSG"].getPage=function(self)--dynamic pages need to be this way
  acarsSystem.messages[acarsSystem.currentMessage]["read"]=true
  local msg=acarsSystem.messages[acarsSystem.currentMessage]
  fmsPages["VIEWACARSMSG"]["template"]={

  "     ACARS-MESSAGE      ",
  "                        ",
  msg["title"],
  "                        ",
  string.sub(msg["msg"],1,24),
  string.sub(msg["msg"],25,48),
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "<RETURN                 "
  }
  return fmsPages["VIEWACARSMSG"]["template"]
end
fmsFunctionsDefs["VIEWACARSMSG"]["L6"]={"setpage","ACARSMSGS"}