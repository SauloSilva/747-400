--5.33.47
fmsPages["WHENCANWE"]=createPage("WHENCANWE")
fmsPages["WHENCANWE"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    local wcwCRZCLB=getFMSData("acarsWCWCRZCLB")
    local wcwCLB=getFMSData("acarsWCWCLB")
    local wcwDES=getFMSData("acarsWCWDES")
    local wcwSPD=getFMSData("acarsWCWSPEED")
    setFMSData("acarsWCWorREQ","WHEN CAN WE")
    return{

"   WHEN CAN WE EXPECT   ",
"                        ",	               
wcwCRZCLB.."                   ",
"                        ",
wcwCLB.."                   ",
"                        ",
wcwDES.."                   ",
"                        ",
".".. wcwSPD .."                     ",
"                        ",
"<ERASE WHEN CAN WE      ",
"------------------------",
"<INDEX           VERIFY>"
    }
end

fmsPages["WHENCANWE"].getSmallPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    return{
"                        ",      
" CRZ CLB TO             ",
"                        ",	               
" CLIMB TO               ",
"             HIGHER ALT>",
" DESCENT TO             ",
"              LOWER ALT>",
" SPEED                  ",
"            BACK ON RTE>",
"                        ",
"                        ",
"                        ",
"                        "
    }
end


  
fmsFunctionsDefs["WHENCANWE"]={}
fmsFunctionsDefs["WHENCANWE"]["L6"]={"setpage","ATCINDEX"}
fmsFunctionsDefs["WHENCANWE"]["L1"]={"setdata","acarsWCWCRZCLB"}
fmsFunctionsDefs["WHENCANWE"]["L2"]={"setdata","acarsWCWCLB"}
fmsFunctionsDefs["WHENCANWE"]["L3"]={"setdata","acarsWCWDES"}
fmsFunctionsDefs["WHENCANWE"]["L4"]={"setdata","acarsWCWSPEED"}
fmsFunctionsDefs["WHENCANWE"]["L5"]={"clearwce",""}
fmsFunctionsDefs["WHENCANWE"]["R2"]={"setacars","WHEN CAN WE EXPECT HIGHER ALT"}
fmsFunctionsDefs["WHENCANWE"]["R3"]={"setacars","WHEN CAN WE EXPECT LOWER ALT"}
fmsFunctionsDefs["WHENCANWE"]["R4"]={"setacars","WHEN CAN WE EXPECT BACK ON RTE"}
fmsFunctionsDefs["WHENCANWE"]["R6"]={"setpage","ATCVERIFYREQUEST"}
