
--This script was made by crazytimtimtim


registerFMCCommand("sim/flight_controls/door_open_1","OPEN DOOR 1")
registerFMCCommand("sim/flight_controls/door_close_1","CLOSE DOOR 1")
registerFMCCommand("sim/flight_controls/door_open_2","OPEN DOOR 2")
registerFMCCommand("sim/flight_controls/door_close_2","CLOSE DOOR 2")


fmsPages["DOORS"]=createPage("DOORS")
fmsPages["DOORS"].getPage=function(self,pgNo,fmsID)
return {
"    DOOR CONTROL 1/3    ",
"                        ",
"<OPEN             CLOSE>",
"                        ", 
"<OPEN             CLOSE>",
"                        ", 
"<OPEN             CLOSE>",
"                        ",
"<OPEN             CLOSE>",
"                        ",
"<OPEN             CLOSE>",
"------------------------",
"<GND HANDLE   NEXT PAGE>"
}
end

fmsFunctionsDefs["DOORS"]={}
fmsFunctionsDefs["DOORS"]["L1"]={"doCMD","sim/flight_controls/door_open_2"}
fmsFunctionsDefs["DOORS"]["R1"]={"doCMD","sim/flight_controls/door_close_2"}
fmsFunctionsDefs["DOORS"]["L3"]={"doCMD","sim/flight_controls/door_open_1"}
fmsFunctionsDefs["DOORS"]["R3"]={"doCMD","sim/flight_controls/door_close_1"}
fmsFunctionsDefs["DOORS"]["L6"]={"setpage","GNDHNDL"}
fmsFunctionsDefs["DOORS"]["R6"]={"setpage","DOORS2"}

fmsPages["DOORS"].getSmallPage=function(self,pgNo,fmsID)
    return {
    "                        ",
    "          FWD L         ",
    "                        ",
    "      FWD R (INOP)      ",
    "                        ",
    "         UPPER L        ",
    "                        ",
    "     UPPER R (INOP)     ",
    "                        ",
    "    FWD WING L (INOP)   ",
    "                        ",
    "                        ",
    "                        "
    }
end


-- Page 2


fmsPages["DOORS2"]=createPage("DOORS2")
fmsPages["DOORS2"].getPage=function(self,pgNo,fmsID)
return {

"    Door Control 2/3    ",
"                        ",
"<OPEN             CLOSE>",
"                        ",
"<OPEN             CLOSE>",
"                        ",
"<OPEN             CLOSE>",
"                        ",
"<OPEN             CLOSE>",
"                        ",
"<OPEN             CLOSE>",
"------------------------",
"<PREV PAGE    NEXT PAGE>"
}
end

fmsFunctionsDefs["DOORS2"]={}
fmsFunctionsDefs["DOORS2"]["L6"]={"setpage","DOORS"}
fmsFunctionsDefs["DOORS2"]["R6"]={"setpage","DOORS3"}

fmsPages["DOORS2"].getSmallPage=function(self,pgNo,fmsID)
    return {
    "                        ",
    "   FWD WING L (INOP)    ",
    "                        ",
    "     WING L (INOP)      ",
    "                        ",
    "     WING R (INOP)      ",
    "                        ",
    "   AFT WING L (INOP)    ",
    "                        ",
    "   AFT WING R (INOP)    ",
    "                        ",
    "                        ",
    "                        "
    }
end


-- Page 3


fmsPages["DOORS3"]=createPage("DOORS3")
fmsPages["DOORS3"].getPage=function(self,pgNo,fmsID)
return {

"    Door Control 3/3    ",
"                        ",
"<OPEN             CLOSE>",
"                        ",
"<OPEN             CLOSE>",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"------------------------",
"<PREV PAGE   GND HANDLE>"
}
end

fmsFunctionsDefs["DOORS3"]={}
fmsFunctionsDefs["DOORS3"]["L6"]={"setpage","DOORS2"}
fmsFunctionsDefs["DOORS3"]["R6"]={"setpage","GNDHNDL"}

fmsPages["DOORS3"].getSmallPage=function(self,pgNo,fmsID)
    return {
    "                        ",
    "      AFT L (INOP)      ",
    "                        ",
    "      AFT R (INOP)      ",
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
end


--[[ This is for making it a dynamic page in the future. The problem with this is if multiple doors are open, it won't work.

if sim/cockpit2/switches/door_open == [0,1,0,0,0,0,0,0,0,0] then
  lineA = "<CLOSE         Forward L"
  else
  lineA = "<OPEN          Forward L"
end

if sim/cockpit2/switches/door_open == [1,0,0,0,0,0,0,0,0,0] then
  lineB = "<CLOSE           Upper L"
  else
  lineB = "<OPEN            Upper L"
end
]]