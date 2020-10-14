fmsPages["MAINTSIMCONFIG"]=createPage("MAINTSIMCONFIG")
fmsPages["MAINTSIMCONFIG"].getPage=function(self,pgNo,fmsID)

  return {

  "   SIM CONFIGURATION    ",
  "                        ",
  ""..fmsModules["data"]["fuelUnits"],
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "                        ",
  "<MAINT                  "
  }
end

fmsPages["MAINTSIMCONFIG"].getSmallPage=function(self,pgNo,fmsID)
  return {
  "                        ",
  "FUEL WEIGHT             ",
  "     (KGS/LBS)          ",
  "                        ",
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
fmsFunctionsDefs["MAINTSIMCONFIG"]["L1"]={"setdata","fuelUnits"}
fmsFunctionsDefs["MAINTSIMCONFIG"]["L6"]={"setpage","MAINT"}