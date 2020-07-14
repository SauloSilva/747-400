fmsPages["THRUSTLIM"]=createPage("THRUSTLIM")
simDR_OAT=find_dataref("sim/weather/temperature_ambient_c")
fmsPages["THRUSTLIM"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
  local t1="     "
  local t2="     "
  local t3="     "
  if toderate==0 then t1="<SEL>" end
  if toderate==1 then t2="<SEL>" end
  if toderate==2 then t3="<SEL>" end
  local c1="     "
  local c2="     "
  local c3="     "
  if clbderate==0 then c1="<ARM>" end
  if clbderate==1 then c2="<ARM>" end
  if clbderate==2 then c3="<ARM>" end
    return{
"       THRUST LIM       ",
"                        ",
""..fmsModules["data"]["thrustsel"] .."`C      "..string.format("%02d",simDR_OAT).."`C         ",
"                        ",
"<TO   "..t1.." "..c1.."    CLB>",
"                        ",
"<TO 1 "..t2.." "..c2.."  CLB 1>",
"                        ",
"<TO 2 "..t3.." "..c3.."  CLB 2>",
"                        ",
"                        ", 
"------------------------",
"<INDEX          TAKEOFF>"
         }
end

fmsPages["THRUSTLIM"]["templateSmall"]={
"                        ",
" SEL      OAT D-TO 1 N1 ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"  10%                   ",
"                        ",
"  20%                   ",
"                        ", 
"                        ",
"                        "
}

--[[ Only if in the air!
fmsPages["THRUSTLIM"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    return{
"       THRUST LIM       ",
"                        ",
"             "..fmsModules["data"]["thrustn1"],
"                        ",
"<GA                 CLB>",
"                        ",
"<CON              CLB 1>",
"                        ",
"<CRZ              CLB 2>",
"                        ",
"                        ", 
"------------------------",
"<INDEX         APPROACH>"
         }
end

fmsPages["THRUSTLIM"]["templateSmall"]={
"                        ",
"               CLB 1 N1 ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"  5%                    ",
"                        ",
"  20%                   ",
"                        ", 
"                        ",
"                        "
}

]]

fmsFunctionsDefs["THRUSTLIM"]={}


fmsFunctionsDefs["THRUSTLIM"]["L1"]={"setdata","thrustsel"}
fmsFunctionsDefs["THRUSTLIM"]["L2"]={"setDref","TO"}
fmsFunctionsDefs["THRUSTLIM"]["L3"]={"setDref","TO1"}
fmsFunctionsDefs["THRUSTLIM"]["L4"]={"setDref","TO2"}
fmsFunctionsDefs["THRUSTLIM"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["THRUSTLIM"]["R1"]={"setdata","thrustn1"}
fmsFunctionsDefs["THRUSTLIM"]["R2"]={"setDref","CLB"}
fmsFunctionsDefs["THRUSTLIM"]["R3"]={"setDref","CLB1"}
fmsFunctionsDefs["THRUSTLIM"]["R4"]={"setDref","CLB2"}
fmsFunctionsDefs["THRUSTLIM"]["R6"]={"setpage","TAKEOFF"}