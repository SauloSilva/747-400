fmsPages["MAINTSIMCONFIG"]=createPage("MAINTSIMCONFIG")
fmsPages["MAINTSIMCONFIG"].getPage=function(self,pgNo,fmsID)
	local display_weight_units

	if simConfigData["data"].weight_display_units == "KGS" then
		display_weight_units = simConfigData["data"].weight_display_units.."/"
	else
		display_weight_units = "   /"..simConfigData["data"].weight_display_units
	end
	
  return {
  "   SIM CONFIGURATION    ",
  "                        ",
  ""..display_weight_units,  --.."             "..simConfigData["data"].irs_align_time,
  "                        ",
  "<CONFIG PAUSE           ",
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
	local display_weight_units = "KGS"
	
	if simConfigData["data"].weight_display_units == "KGS" then
		display_weight_units = "    LBS"
	else
		display_weight_units = "KGS"
	end

  return {
  "                        ",
  "WEIGHT UNITS            ", --IRS ALIGN",
  ""..display_weight_units,   --.."             mins",
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
fmsFunctionsDefs["MAINTSIMCONFIG"]["L1"]={"setdata","weightUnits"}
fmsFunctionsDefs["MAINTSIMCONFIG"]["L2"]={"setpage","VNAVCONFIG"}
--fmsFunctionsDefs["MAINTSIMCONFIG"]["R1"]={"setdata","irsAlignTime"}
fmsFunctionsDefs["MAINTSIMCONFIG"]["L6"]={"setpage","MAINT"}

fmsPages["VNAVCONFIG"]=createPage("VNAVCONFIG")
fmsPages["VNAVCONFIG"].getPage=function(self,pgNo,fmsID)
  local LineA="<ENABLE PAUSE AT T/D    "	
  local LineB="<PAUSE AT ***NM TO DEST "	
  if B747DR_ap_vnav_pause ==1.0 then 
      LineA="<DISABLE PAUSE AT T/D   "
      if B747BR_tod>0 then 
        LineB="<PAUSE AT ".. string.format("%03d",B747BR_tod) .."NM TO DEST "
      end

  elseif B747DR_ap_vnav_pause >1.0 then 
      LineA="<DISABLE PAUSE          "
      LineB="<PAUSE AT ".. string.format("%03d",B747DR_ap_vnav_pause) .."NM TO DEST "    
  end
  return {

  "      CONFIG PAUSE      ",
  "                        ",
  LineA,
  "                        ",
  LineB,
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


fmsFunctionsDefs["VNAVCONFIG"]["L1"]={"setDref","VNAVSPAUSE"}
fmsFunctionsDefs["VNAVCONFIG"]["L2"]={"setDref","PAUSEVAL"}