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
