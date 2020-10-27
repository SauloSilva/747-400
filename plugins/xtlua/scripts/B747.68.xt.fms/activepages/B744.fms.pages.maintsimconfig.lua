fmsPages["MAINTSIMCONFIG"]=createPage("MAINTSIMCONFIG")
fmsPages["MAINTSIMCONFIG"].getPage=function(self,pgNo,fmsID)
	local current_units = fmsModules["data"]["fuelUnits"]
	local display_fuel_units
	
	if current_units == "KGS" then
		display_fuel_units = current_units.."/"
	else
		display_fuel_units = "   /"..current_units
	end
	
  return {
  "   SIM CONFIGURATION    ",
  "                        ",
  ""..display_fuel_units,
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
	local current_units = fmsModules["data"]["fuelUnits"]
	local display_fuel_units
	
	if current_units == "KGS" then
		display_fuel_units = "    LBS"
	else
		display_fuel_units = "KGS"
	end

  return {
  "                        ",
  "FUEL WEIGHT             ",
  ""..display_fuel_units,
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