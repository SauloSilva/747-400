fmsPages["ATCREQUEST"]=createPage("ATCREQUEST")
fmsPages["ATCREQUEST"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    local reqAlt=getFMSData("acarsREQALT")
    if string.len(fmsModules[fmsID]["scratchpad"])>0 then
        fmsFunctionsDefs["ATCREQUEST"]["L1"]={"setdata","acarsREQALT"}
    else
        fmsFunctionsDefs["ATCREQUEST"]["L1"]={"setpage","ATCSUBREQUEST_1"}
    end
    local reqSpd=getFMSData("acarsREQSPEED")
    if string.len(fmsModules[fmsID]["scratchpad"])>0 then
        fmsFunctionsDefs["ATCREQUEST"]["L2"]={"setdata","acarsREQSPEED"}
    else
        fmsFunctionsDefs["ATCREQUEST"]["L2"]={"setpage","ATCSUBREQUEST_2"}
    end
    local reqoffset=getFMSData("acarsREQOFFSET")
    if string.len(fmsModules[fmsID]["scratchpad"])>0 then
        fmsFunctionsDefs["ATCREQUEST"]["L3"]={"setdata","acarsREQOFFSET"}
    else
        fmsFunctionsDefs["ATCREQUEST"]["L3"]={"setpage","ATCSUBREQUEST_3"}
    end
    return{

"       ATC REQUEST      ",
"                        ",
"<"..reqAlt .."                  ",
"                        ",
"<."..reqSpd.."                    ",
"                        ",
"<"..reqoffset.."                    ",
"                        ",
"<ROUTE REQUEST          ",
"                        ",
"<ERASE REQUEST          ",
"------------------------",
"<INDEX           VERIFY>"
    }
end

fmsPages["ATCREQUEST"].getSmallPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    return{
"                        ",      
" ALTITUDE               ",
"                        ",	               
" SPEED                  ",
"                        ",
" OFFSET                 ",
"    NM                  ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        "
    }
end


  
fmsFunctionsDefs["ATCREQUEST"]={}
fmsFunctionsDefs["ATCREQUEST"]["L4"]={"setpage","ATCSUBREQUEST_4"}
fmsFunctionsDefs["ATCREQUEST"]["L6"]={"setpage","ATCINDEX"}
fmsFunctionsDefs["ATCREQUEST"]["R6"]={"setpage","ATCVERIFYREQUEST"}

fmsPages["ATCSUBREQUEST"]=createPage("ATCSUBREQUEST")
fmsPages["ATCSUBREQUEST"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    if pgNo==1 then
        local reqAlt=getFMSData("acarsREQALT")
        fmsFunctionsDefs["ATCSUBREQUEST"]["L1"]={"setdata","acarsREQALT"}
        fmsFunctionsDefs["ATCSUBREQUEST"]["L2"]=nil
        fmsFunctionsDefs["ATCSUBREQUEST"]["R1"]=nil
        fmsFunctionsDefs["ATCSUBREQUEST"]["R2"]=nil
    return{

"     ATC ALT REQUEST    ",
"                        ",
"<"..reqAlt .."                  ",
"                        ",
" -----                  ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"------------------------",
"<REQUEST         VERIFY>"
    }
    elseif pgNo==2 then
        local reqSpd=getFMSData("acarsREQSPEED")
        fmsFunctionsDefs["ATCSUBREQUEST"]["L1"]={"setdata","acarsREQSPEED"}
        fmsFunctionsDefs["ATCSUBREQUEST"]["L2"]=nil
        fmsFunctionsDefs["ATCSUBREQUEST"]["R1"]=nil
        fmsFunctionsDefs["ATCSUBREQUEST"]["R2"]=nil
        return{

            "   ATC SPEED REQUEST    ",
            "                        ",
            "."..reqSpd .."                  ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "------------------------",
            "<REQUEST         VERIFY>"
                }
    elseif pgNo==3 then
        local reqoffset=getFMSData("acarsREQOFFSET")
        local reqat=getFMSData("acarsREQAT")
        fmsFunctionsDefs["ATCSUBREQUEST"]["L1"]={"setdata","acarsREQOFFSET"}
        fmsFunctionsDefs["ATCSUBREQUEST"]["L2"]={"setdata","acarsREQAT"}
        fmsFunctionsDefs["ATCSUBREQUEST"]["R1"]=nil
        fmsFunctionsDefs["ATCSUBREQUEST"]["R2"]=nil
        return{

            "   ATC OFFSET REQUEST   ",
            "                        ",
            ""..reqoffset .."                   ",
            "                        ",
            ""..reqat .."                   ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "------------------------",
            "<REQUEST         VERIFY>"
                }
    elseif pgNo==4 then
        local reqto=getFMSData("acarsREQTO")
        local reqheading=getFMSData("acarsREQHDG")
        local reqtrack=getFMSData("acarsREQTRK")
        fmsFunctionsDefs["ATCSUBREQUEST"]["L1"]={"setdata","acarsREQTO"}
        fmsFunctionsDefs["ATCSUBREQUEST"]["L2"]=nil
        fmsFunctionsDefs["ATCSUBREQUEST"]["R1"]={"setdata","acarsREQHDG"}
        fmsFunctionsDefs["ATCSUBREQUEST"]["R2"]={"setdata","acarsREQTRK"}
        return{

            "   ATC ROUTE REQUEST    ",
            "                        ",
            ""..reqto .."                "..reqheading,
            "                        ",
            "                     "..reqtrack,
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "------------------------",
            "<REQUEST         VERIFY>"
                }
    end
end

fmsPages["ATCSUBREQUEST"].getSmallPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    if pgNo==1 then
    return{
"                     1/4",
" ALTITUDE        REQUEST",
"                CRZ CLB>",
" STEP AT    MAINTAIN OWN",
"         SEPARATION/VMC>",
"                  DUE TO",
"            PERFORMANCE>",
"                  DUE TO",
"<AT PILOT DISC   WEATHER",
"                        ",
"                        ",
"                        ",
"                        "
    }
    elseif pgNo==2 then
        return{
            "                     2/4",
            " SPEED                  ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                  DUE TO",
            "            PERFORMANCE>",
            "                  DUE TO",
            "                WEATHER>",
            "                        ",
            "                        ",
            "                        "
            }
    elseif pgNo==3 then
        return{
            "                     3/4",
            " OFFSET                 ",
            "                        ",
            " OFFSET AT              ",
            "                        ",
            "                        ",
            "                        ",
            "                        ",
            "                  DUE TO",
            "                WEATHER>",
            "                        ",
            "                        ",
            "                        "
            }
    elseif pgNo==4 then
            return{
            "                     4/4",
            " DIRECT TO       HEADING",
            "                        ",
            "            GROUND TRACK",
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
end


  
fmsFunctionsDefs["ATCSUBREQUEST"]={}
fmsFunctionsDefs["ATCSUBREQUEST"]["L6"]={"setpage","ATCREQUEST"}
fmsFunctionsDefs["ATCSUBREQUEST"]["R6"]={"setpage","ATCVERIFYREQUEST"}
fmsPages["ATCSUBREQUEST"].getNumPages=function(self)
    return 4
end



fmsPages["ATCVERIFYREQUEST"]=createPage("ATCVERIFYREQUEST")
fmsPages["ATCVERIFYREQUEST"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    if pgNo==1 then 
    return{

"     VERIFY REQUEST     ",
"                        ",	               
" ----                   ",
"                        ",
" ---                    ",
"                        ",
" FL---                  ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"<REQUEST                "
    }
    elseif pgNo==2 then
      return{

"     VERIFY REQUEST     ",
"                        ",	               
"<                       ",
"                        ",
"<                       ",
"                        ",
"<                       ",
"                        ",
"<                       ",
"                        ",
"                   SEND>",
"                        ",
"<REQUEST                "
    }
    end
end

fmsPages["ATCVERIFYREQUEST"].getSmallPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    if pgNo==1 then 
    return{
"                     1/2",      
" AT                     ",
"                        ",	               
" REQUEST OFFSET         ",
"    NM                  ",
"/REQUEST CLIMB TO       ",
"                        ",
"/DUE TO                 ",
"                        ",
"/REQUEST                ",
"                        ",
"--------CONTINUED-------",
"                        "
    }
    elseif pgNo==2 then
      return{
"                     2/2",      
"/FREE TEXT              ",
"                        ",	               
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                        ",
"                 REQUEST",
"                        ",
"------------------------",
"                        "
    }
    end
end
fmsPages["ATCVERIFYREQUEST"].getNumPages=function(self)
  return 2 
end

  
fmsFunctionsDefs["ATCVERIFYREQUEST"]={}
fmsFunctionsDefs["ATCVERIFYREQUEST"]["L6"]={"setpage","ATCREQUEST"}