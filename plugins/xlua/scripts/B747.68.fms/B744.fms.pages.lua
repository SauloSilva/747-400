createPage("ACARS")
fmsPage["ACARS"]={
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
createPage("PREFLIGHT")
fmsPage["PREFLIGHT"]={

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
"<RETURN                 "
}-- line 11 LHS = getUTC 
createPage("NAVRAD")
fmsPage["NAVRAD"]={

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
fmsPagesmall["NAVRAD"]={
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
--fmsFunctionsDefs["ACARS"]={}
fmsFunctionsDefs["ACARS"]["L1"]={"setpage","PREFLIGHT"}
--fmsFunctionsDefs["PREFLIGHT"]={}
fmsFunctionsDefs["PREFLIGHT"]["L6"]={"setpage","ACARS"}
--fmsFunctionsDefs["NAVRAD"]={}
fmsFunctionsDefs["NAVRAD"]["L6"]={"setpage","ACARS"}
fmsFunctions={}
function fmsFunctions.setpage(fmsO,value) 
  fmsO["inCustomFMC"]=true
  fmsO["currentPage"]=value 
  print("setpage" .. value)
end