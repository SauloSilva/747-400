--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]
fmsFunctions={}
dofile("acars/acars.lua")
fmsPages["INDEX"]=createPage("INDEX")
fmsPages["INDEX"]["template"]={

"          MENU          ",
"                        ",
"<FMC             SELECT>",
"                        ",
"<ACARS           SELECT>",
"                        ",
"<SAT                    ",
"                        ",
"                        ",
"                        ",
"<ACMS                   ", 
"                        ",
"<CMC                    "
}
fmsPages["INDEX"]["templateSmall"]={
"                        ",
"                 EFIS CP",
"                        ",
"                EICAS CP",
"                        ",
"                 CTL PNL",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
}

fmsFunctionsDefs["INDEX"]={}
fmsFunctionsDefs["INDEX"]["L1"]={"setpage","FMC"}
fmsFunctionsDefs["INDEX"]["L2"]={"setpage","ACARS"}

simDR_variation=find_dataref("sim/flightmodel/position/magnetic_variation")
fmsPages["NAVRAD"]=createPage("NAVRAD")
fmsPages["NAVRAD"].getPage=function(self,pgNo)
  local ils1="                        "
  local ils2="                        "
  if string.len(ilsData)>0 then
    local ilsNav=json.decode(ilsData)
    ils1= ilsNav[7]
    ils2= string.format("%6.2f/%03d%s             ", ilsNav[3]*0.01,(ilsNav[4]+simDR_variation), "˚")
  end
  local page={
    "        NAV RADIO       ",
    "                        ",
    string.format("%6.2f %4s  %4s %6.2f", simDR_radio_nav_freq_hz[0]*0.01, simDR_radio_nav01_ID, simDR_radio_nav02_ID, simDR_radio_nav_freq_hz[1]*0.01),
    string.format("                        ", ""),
    string.format(" %03d     %3s  %3s    %03d", simDR_radio_nav_obs_deg[0], "---", "---", simDR_radio_nav_obs_deg[1]),
    "                        ",
    string.format("%06.1f         %06.1f   ", simDR_radio_adf1_freq_hz, simDR_radio_adf2_freq_hz),
    "                        ",
    ils1,
    ils2,
    "                        ", 
    "                        ",
    "                        "
    }
  return page
end
--fmsPages["NAVRAD"]["template"]=
fmsPages["NAVRAD"]["templateSmall"]={
"                        ",
" VOR L             VOR R",
"                        ",
" CRS      RADIAL     CRS",
"                        ",
" ADF L             ADF R",
"      ANT            ANT",
" ILS                    ",
"                        ",
"           M            ",
"                        ",
"                        ",
"                        ",
}

--fmsFunctionsDefs["NAVRAD"]["L6"]={"setpage","ACARS"}

function fmsFunctions.setpage(fmsO,value)
  fmsO["pgNo"]=1
  
  --sim/FMS/navrad
  --sim/FMS2/navrad
  if value=="FMC" then
    fmsO["inCustomFMC"]=false
    simCMD_FMS_key[fmsO.id]["fpln"]:once()
    simCMD_FMS_key[fmsO.id]["L6"]:once()
  elseif value=="VHFCONTROL" then
    fmsO["inCustomFMC"]=false
    simCMD_FMS_key[fmsO.id]["navrad"]:once()
  else
    fmsO["inCustomFMC"]=true
    fmsO["currentPage"]=value 
 
  end
  print("setpage " .. value)
end

function fmsFunctions.setdata(fmsO,value) 
  if value=="depdst" then
    dep=string.sub(fmsO["scratchpad"],1,4)
    dst=string.sub(fmsO["scratchpad"],-4)
    --fmsModules["data"]["fltdep"]=dep
    --fmsModules["data"]["fltdst"]=dst
    setFMSData("fltdep",dep)
    setFMSData("fltdst",dst)
  elseif value=="flttime" then 
    hhV=string.sub(fmsO["scratchpad"],1,2)
    mmV=string.sub(fmsO["scratchpad"],-2)
    setFMSData("flttimehh",hhV)
    setFMSData("flttimemm",mmV)
  elseif value=="rpttime" then 
    hhV=string.sub(fmsO["scratchpad"],1,2)
    mmV=string.sub(fmsO["scratchpad"],-2)
    setFMSData("rpttimehh",hhV)
    setFMSData("rpttimemm",mmV)
  elseif value=="fltdate" then 
    setFMSData("fltdate",os.date("%Y%m%d"))
  else
    setFMSData(value,fmsO["scratchpad"])
  end
  fmsO["scratchpad"]=""
end

function fmsFunctions.showmessage(fmsO,value)
  acarsSystem.currentMessage=value
  fmsO["inCustomFMC"]=true
  fmsO["currentPage"]="VIEWACARSMSG" 
end