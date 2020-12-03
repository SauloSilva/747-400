fmsPages["CMC"]=createPage("CMC")
fmsPages ["CMC"].getPage=function(self,pgNo,fmsID)

  if pgNo==1 then 
      fmsFunctionsDefs["CMC"]["L1"]={"setpage","PLFAULTS"}
      fmsFunctionsDefs["CMC"]["L2"]={"setpage","CONFTEST"}
      fmsFunctionsDefs["CMC"]["L3"]={"setpage","EMANP"}
      fmsFunctionsDefs["CMC"]["L4"]={"setpage","GRDTEST"}
    return {
            
"     CMC-L MENU      1/2",
"                        ",
"<PRESENT LEG FAULTS     ",
"                        ",
"<CONFIDENCE TESTS       ",
"                        ",
"<EICAS MANIT PAGES      ",
"                        ",
"<GROUND TESTS           ",
"                        ",
"                        ", 
"------------------------",
"                   HELP>"
    }
  elseif pgNo==2 then
      fmsFunctionsDefs["CMC"]["L1"]={"setpage","FAULTS"}
      fmsFunctionsDefs["CMC"]["L2"]={"setpage","FHISTORY"}
      fmsFunctionsDefs["CMC"]["L3"]={"setpage","OFUCNTION"}
    return {
            
"     CMC-L MENU      2/2",
"                        ",
"<EXISTING FAULTS        ",
"                        ",
"<FAULT HISTORY          ",
"                        ",
"<OTHER FUNCTIONS        ",
"                        ",
"------------------------",
"                        ",
"                  NOTES>", 
"                        ",
"                   HELP>"
    }
end
end

fmsPages["GRDTEST"]=createPage("GRDTEST")
fmsPages ["GRDTEST"].getPage=function(self,pgNo,fmsID)

  if pgNo==1 then 
      fmsFunctionsDefs["GRDTEST"]["L1"]={"setpage","GTAC"}
      fmsFunctionsDefs["GRDTEST"]["L2"]={"setpage","GTCABPSI"}
      fmsFunctionsDefs["GRDTEST"]["L3"]={"setpage","GTECS"}
      fmsFunctionsDefs["GRDTEST"]["L4"]={"setpage","GTYAW"}
    return {
            
"    GROUND TESTS     1/6",
"                        ",
"<21 AIR CONDITIONING    ",
"                        ",
"<21 CABIN PRESURE       ",
"                        ",
"<21 EQUIPMENT COOLING   ",
"                        ",
"<22 AUTOPILOT FLT DIR   ",
"                        ",
"<YAW DAMPER             ", 
"------------------------",
"                   HELP>"
    }
