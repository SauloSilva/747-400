fmsPages["ACMS"]=createPage("ACMS")
fmsPages [“ACMS”].getPage=function(self,pgNo,fmsID)

  return {
            
"       ACMS INDEX       ",
"                        ",
"<REPORTS          MANIT>",
"                        ",
"<DOC DATA        STATUS>",
"                        ",
"<DATA DISPLAY  RT PRINT>",
"                        ",
"                        ",
"                        ",
"                        ", 
"------------------------",
"                  PRINT>"
    }
    
      fmsFunctionsDefs["ACMS"]["L1"]={"setpage","REPORTS"}
      fmsFunctionsDefs["ACMS"]["L2"]={"setpage","DOCDATA"}
      fmsFunctionsDefs["ACMS"]["L3"]={"setpage","DATDISP"}
      
      fmsFunctionsDefs["ACMS"]["R1"]={"setpage","MANIT"}
      fmsFunctionsDefs["ACMS"]["R2"]={"setpage","STATUS"}
      fmsFunctionsDefs["ACMS"]["R3"]={"setpage","RTPRINT"}
      
fmsPages["REPORTS"]=createPage("REPORTS")
fmsPages [“REPORTS”].getPage=function(self,pgNo,fmsID)
  if pgNo==1 then
  return {
            
"      ACMS REPORTS   1/2",
" RPT   STORED THIS FLT  ",
" 01 ENG CRUISE        00",
" 02 CRUSE PERF        00",
" 04 ENG TAKEOFF       00",
" 06 ENG GAS PT AD     00",
" 07 ENG MECH ADV      00",
" 09 ENG DIVERG        00",
" 11 ENG RUN UP        00",
" -----------------------",
"--:RPT LOG    TRIGGER:--", 
" RETURN TO              ",
"<ACMS INDEX       PRINT>"
    }
    
  elseif pgNo==2 then
    return {
"      ACMS REPORTS   2/2",
" RPT   STORED THIS FLT  ",
" 13 APU MES/IDL       00",
" 14 APU SHTDWN        00",
" 15 LOAD              00",
" 19 ECS PERF          00",
" 20 AUTOLAND          00",
" 23 ECS EXCEED        00",
" 41 CREW PRF STAT     00",
" -----------------------",
"--:RPT LOG    TRIGGER:--", 
" RETURN TO              ",
"<ACMS INDEX       PRINT>"
    }
end
end
