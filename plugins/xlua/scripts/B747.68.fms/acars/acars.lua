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

acarsSystem.provider={
send=function(value) print("send ACARS message") end,
receive=function(value) print("receive ACARS message") end
}

function fmsFunctions.acarsSystemSend(fmsO,value) 
  acarsSystem.provider.send(value)
  fmsO["inCustomFMC"]=true
  fmsO["currentPage"]="ACARS" 
  --print("setpage" .. value)
end

acarsSystem.messages={{type="msg",msg="Test Message",time="12:00 UTC"},{type="msg",msg="2nd Test Message",time="12:05 UTC"}}

acarsSystem.getMessages=function()
retVal={}
retVal.template={
  "          MSGS          ",
  "                        ",
  "<Test Message           ",
  "                        ",
  "<2nd Test Message       ",
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