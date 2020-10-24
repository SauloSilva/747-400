fmsPages["IDENT"]=createPage("IDENT")
fmsPages["IDENT"].getPage=function(self,pgNo,fmsID)--dynamic pages need to be this way
    return{

 "       IDENT            ",
 "                        ",
 "747-400      CF6-80C2-B1F",
 "                        ",
 "                        ",
 "      "..cleanFMSLine(B747DR_srcfms[fmsID][5]),
 "                        ",
 "                        ",
 "XP1150-2020/10/24       ",
 "                        ",
 "+1.1/-3.5         ******", 
 "------------------------",
 "<INDEX         POS INIT>"
    }
end

fmsPages["IDENT"]["templateSmall"]={
"                        ",
" MODEL           ENGINES",
"                        ",
" NAV DATA         ACTIVE",
"                        ",
"                        ",
"                        ",
" OP PROGRAM             ",
"                        ",
" DRAG/FF         CO DATA",
"                        ", 
"                        ",
"                        "
}


  
  
fmsFunctionsDefs["IDENT"]={}
fmsFunctionsDefs["IDENT"]["L6"]={"setpage","INITREF"}
fmsFunctionsDefs["IDENT"]["R6"]={"setpage","POSINIT"}

