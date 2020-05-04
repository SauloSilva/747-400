--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]
fmsFunctions={}
dofile("acars/acars.lua")

fmsPages["NAVRAD"]=createPage("NAVRAD")
fmsPages["NAVRAD"]["template"]={

"        NAV RADIO       ",
"                        ",
string.format("%6.2f %4s  %4s %6.2f", simDR_radio_nav_freq_hz[2]*0.01, simDR_radio_nav03_ID, simDR_radio_nav04_ID, simDR_radio_nav_freq_hz[3]*0.01),
string.format("                        ", ""),
string.format(" %03d     %3s  %3s    %03d", simDR_radio_nav_obs_deg[2], "---", "---", simDR_radio_nav_obs_deg[3]),
"                        ",
string.format("%06.1f         %06.1f   ", simDR_radio_adf1_freq_hz, simDR_radio_adf2_freq_hz),
"                        ",
string.format("%6.2f/%03d%s             ", simDR_radio_nav_freq_hz[0]*0.01, simDR_radio_nav_obs_deg[0], "˚"),
"                        ",
"                        ", 
"                        ",
"<ACARS                  "
}
fmsPages["NAVRAD"]["templateSmall"]={
"                        ",
" VOR L             VOR R",
"      M         M       ",
" CRS      RADIAL     CRS",
"                        ",
" ADF L             ADF R",
"      ANT            ANT",
" ILS                    ",
"           M            ",
"                        ",
"                        ",
"                        ",
"                        ",
}

fmsFunctionsDefs["INDEX"]={}
fmsFunctionsDefs["INDEX"]["L3"]={"setpage","ACARS"}

fmsFunctionsDefs["NAVRAD"]["L6"]={"setpage","ACARS"}

function fmsFunctions.setpage(fmsO,value) 
  fmsO["inCustomFMC"]=true
  fmsO["currentPage"]=value 
  --print("setpage" .. value)
end