--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*****************************************************************************************
]]
simDRTime=find_dataref("sim/time/total_running_time_sec")
simDR_onGround=find_dataref("sim/flightmodel/failures/onground_all")


B747DR_acfType               = find_dataref("laminar/B747/acfType")
B747DR_payload_weight               = find_dataref("sim/flightmodel/weight/m_fixed")
simDR_acf_m_jettison  		=find_dataref("sim/aircraft/weight/acf_m_jettison")
simDR_m_jettison  		=find_dataref("sim/flightmodel/weight/m_jettison")
B747DR_CAS_advisory_status       = find_dataref("laminar/B747/CAS/advisory_status")
B747DR_ap_vnav_system            = find_dataref("laminar/B747/autopilot/vnav_system")
B747DR_ap_vnav_pause            = find_dataref("laminar/B747/autopilot/vnav_pause")
simDR_nav1Freq			 =find_dataref("sim/cockpit/radios/nav1_freq_hz")
simDR_nav2Freq			 =find_dataref("sim/cockpit/radios/nav2_freq_hz")
B747DR_iru_status         	= find_dataref("laminar/B747/flt_mgmt/iru/status")
B747DR_iru_mode_sel_pos         = find_dataref("laminar/B747/flt_mgmt/iru/mode_sel_dial_pos")

B747DR_rtp_C_off 		 = find_dataref("laminar/B747/comm/rtp_C/off_status")
B747DR_pfd_mode_capt		 = find_dataref("laminar/B747/pfd/capt/irs")
B747DR_pfd_mode_fo		 = find_dataref("laminar/B747/pfd/fo/irs")
B747DR_irs_src_fo		 = find_dataref("laminar/B747/flt_inst/irs_src/fo/sel_dial_pos")
B747DR_irs_src_capt		 = find_dataref("laminar/B747/flt_inst/irs_src/capt/sel_dial_pos")
B747DR_ap_fpa	    = find_dataref("laminar/B747/autopilot/navadata/fpa")
B747DR_ap_vb	    = find_dataref("laminar/B747/autopilot/navadata/vb")
simDR_autopilot_vs_fpm         			= find_dataref("sim/cockpit2/autopilot/vvi_dial_fpm")
B747DR_fmc_notifications            = find_dataref("laminar/B747/fms/notification")
--Workaround for stack overflow in init.lua namespace_read

KGS_TO_LBS = 2.2046226218488

function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end
function hasChild(parent,childKey)
  if(parent==nil) then
    return false
  end
  local keyFuncs=rawget(parent,'values')
  if keyFuncs==nil then return false end
  local keyFunc=rawget(keyFuncs,childKey)
  if keyFunc==nil then return false end
 
  return true
end
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
function cleanFMSLine(line)
    local retval=line:gsub("☐","*")
    retval=retval:gsub("°","`")
    return retval
end 
function getHeadingDifference(desireddirection,current_heading)
	error = current_heading - desireddirection
	if (error >  180) then error =error- 360 end
	if (error < -180) then error =error+ 360 end
	return error
end
function getHeadingDifferenceM(desireddirection,current_heading)
	error = current_heading - desireddirection
	if (error >  180) then error =error- 360 end
	if (error < -180) then error =error+ 360 end
	if error<0 then error = error *-1 end
	return error
end
function getDistance(lat1,lon1,lat2,lon2)
  alat=math.rad(lat1)
  alon=math.rad(lon1)
  blat=math.rad(lat2)
  blon=math.rad(lon2)
  av=math.sin(alat)*math.sin(blat) + math.cos(alat)*math.cos(blat)*math.cos(blon-alon)
  if av > 1 then av=1 end
  retVal=math.acos(av) * 3440
  --print(lat1.." "..lon1.." "..lat2.." "..lon2)
  --print("Distance = "..retVal) 
  return retVal
end

function toDMS(value,isLat)
  degrees=value
  if value<0 then
    degrees=degrees*-1
   end
  minutes=(value-math.floor(value))*60
  seconds=minutes-math.floor(minutes)
  local p="N"
  if isLat==true and value<0 then 
    p="W"
  elseif isLat==true then  
    p="E"
  elseif value<0 then
    p="S"
  end
  retVal=string.format(p .. "%03d`%02d.%1d",degrees,minutes,seconds*10)
  return retVal
end
function deferred_command(name,desc,realFunc)
	return replace_command(name,realFunc)
end
--replace deferred_dataref
function deferred_dataref(name,nilType,callFunction)
  if callFunction~=nil then
    print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end
dofile("json/json.lua")
hh=find_dataref("sim/cockpit2/clock_timer/zulu_time_hours")
mm=find_dataref("sim/cockpit2/clock_timer/zulu_time_minutes")
ss=find_dataref("sim/cockpit2/clock_timer/zulu_time_seconds")
simDR_bus_volts               = find_dataref("sim/cockpit2/electrical/bus_volts")
simDR_startup_running               = find_dataref("sim/operation/prefs/startup_running")

simDR_instrument_brightness_switch  = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio")
simDR_instrument_brightness_ratio   = find_dataref("sim/cockpit2/electrical/instrument_brightness_ratio_manual")

simDR_radio_nav_freq_Mhz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_Mhz")
simDR_radio_nav_freq_khz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_khz")
simDR_radio_nav_freq_hz             = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_hz")

simDR_radio_nav_course_deg          = find_dataref("sim/cockpit2/radios/actuators/nav_course_deg_mag_pilot")
simDR_radio_nav_obs_deg             = find_dataref("sim/cockpit2/radios/actuators/nav_obs_deg_mag_pilot")
simDR_radio_nav_horizontal          = find_dataref("sim/cockpit2/radios/indicators/nav_display_horizontal")
simDR_radio_nav_hasDME              = find_dataref("sim/cockpit2/radios/indicators/nav_has_dme")
simDR_radio_nav_radial		    = find_dataref("sim/cockpit2/radios/indicators/nav_bearing_deg_mag")
simDR_radio_nav01_ID                = find_dataref("sim/cockpit2/radios/indicators/nav1_nav_id")
simDR_radio_nav02_ID                = find_dataref("sim/cockpit2/radios/indicators/nav2_nav_id")
simDR_radio_nav03_ID                = find_dataref("sim/cockpit2/radios/indicators/nav3_nav_id")
simDR_radio_nav04_ID                = find_dataref("sim/cockpit2/radios/indicators/nav4_nav_id")

simDR_radio_adf1_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf1_frequency_hz")
simDR_radio_adf2_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf2_frequency_hz")

simDR_fueL_tank_weight_total_kg     = find_dataref("sim/flightmodel/weight/m_fuel_total")

navAidsJSON   = find_dataref("xtlua/navaids")
fmsJSON = find_dataref("xtlua/fms")

B747DR_fms1_display_mode            = find_dataref("laminar/B747/fms1/display_mode")

B747DR_init_fmsL_CD                 = find_dataref("laminar/B747/fmsL/init_CD")
ilsData=deferred_dataref("laminar/B747/radio/ilsData", "string")
acars=deferred_dataref("laminar/B747/comm/acars","number")  
toderate=deferred_dataref("laminar/B747/engine/derate/TO","number") 
clbderate=deferred_dataref("laminar/B747/engine/derate/CLB","number")
B747DR_radioModes=deferred_dataref("laminar/B747/radio/tuningmodes", "string")
B747DR_FMSdata=deferred_dataref("laminar/B747/fms/data", "string")
B747DR_ap_vnav_state                = find_dataref("laminar/B747/autopilot/vnav_state")
simDR_autopilot_vs_status          = find_dataref("sim/cockpit2/autopilot/vvi_status")
B747BR_totalDistance 			= find_dataref("laminar/B747/autopilot/dist/remaining_distance")
B747BR_nextDistanceInFeet 		= find_dataref("laminar/B747/autopilot/dist/next_distance_feet")
B747BR_cruiseAlt 			= find_dataref("laminar/B747/autopilot/dist/cruise_alt")
B747BR_tod				= find_dataref("laminar/B747/autopilot/dist/top_of_descent")
B747DR__gear_chocked           = find_dataref("laminar/B747/gear/chocked")
B747DR_fuel_preselect		= find_dataref("laminar/B747/fuel/preselect")
B747DR_refuel				= find_dataref("laminar/B747/fuel/refuel")
B747DR_fuel_add				= find_dataref("laminar/B747/fuel/add_fuel")

--Used in ND DISPLAY
simDR_ND_speed				= find_dataref("sim/cockpit2/radios/indicators/gps_dme_speed_kts")
simDR_latitude				= find_dataref("sim/flightmodel/position/latitude")
simDR_longitude				= find_dataref("sim/flightmodel/position/longitude")
simDR_navID					= find_dataref("sim/cockpit2/radios/indicators/gps_nav_id")
simDR_range_dial_capt		= find_dataref("laminar/B747/nd/range/capt/sel_dial_pos")
simDR_range_dial_fo			= find_dataref("laminar/B747/nd/range/fo/sel_dial_pos")


--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--

-- CRT BRIGHTNESS DIAL ------------------------------------------------------------------
B747DR_fms1_display_brightness      = deferred_dataref("laminar/B747/fms1/display_brightness", "number", B747_fms1_display_brightness_DRhandler)

-- FUEL WEIGHT DISPLAY UNITS (KGS/LBS)
B747DR_fuel_display_units				= deferred_dataref("laminar/B747/fuel/fuel_display_units", "string")
B747DR_fuel_display_units_eicas			= deferred_dataref("laminar/B747/fuel/fuel_display_units_eicas", "number")
B747DR_fuel_preselect_temp				= deferred_dataref("laminar/B747/fuel/fuel_preselect_temp", "number")

--ETA for ND DISPLAY
B747DR_ND_waypoint_eta					= deferred_dataref("laminar/B747/nd/waypoint_eta", "string")
B747DR_ND_current_waypoint				= deferred_dataref("laminar/B747/nd/current_waypoint", "string")
B747DR_ND_waypoint_distance				= deferred_dataref("laminar/B747/nd/waypoint_distance", "string")

--ND Range DISPLAY
B747DR_ND_range_display_capt			= deferred_dataref("laminar/B747/nd/range_display_capt", "number")
B747DR_ND_range_display_fo				= deferred_dataref("laminar/B747/nd/range_display_fo", "number")

fmsPages={}
--fmsPagesmall={}
fmsFunctionsDefs={}
fmsModules={} --set later
fmsModules["data"]={
  acarsInitString="{}",
  fltno="*******",
  fltdate="********",
  fltdep="****",
  fltdst="****",
  flttimehh="**",
  flttimemm="**",
  rpttimehh="**",
  rpttimemm="**",
  acarsAddress="*******",
  atc="****",
  grwt="***.*",
  crzalt="*****",
  clbspd="250",
  transpd="272",
  spdtransalt="10000",
  transalt="18000",
  clbrestspd="180",
  clbrestalt="5000 ",
  stepalt="FL360",
  crzspd="810",
  desspdmach="805",
  desspd="270",
  destranspd="240",
  desspdtransalt="10000",
  desrestspd="180",
  desrestalt="5000 ",
  fpa="*.*",
  vb="*.*",
  vs="****",
  fuel="***.*",
  zfw="***.*",
  reserves="***.*",
  costindex="****",
  crzcg="**.*",
  thrustsel="26",
  thrustn1="**.*",
  toflap="**",
  v1="***",
  vr="***",
  v2="***",
  runway="*****",
  coroute="*****",
  grosswt="***.*",
  vref1="***",
  vref2="***",
  irsLat="****`**.*",
  irsLon="****`**.*",
  initIRSLat="****`**.*",
  initIRSLon="****`**.*",
  flapspeed="**/***",
  airportpos="*****",
  airportgate="*****",
  preselectLeft="******",
  preselectRight="******",
  fuelUnits="KGS",   --Set initial fuel weight units
}
B747DR_FMSdata=json.encode(fmsModules["data"]["values"])--make the fms data available to other modules
fmsModules["setData"]=function(self,id,value)
    --always retain the same length
    if value=="" then value="***********" end
    len=string.len(self["data"][id])
    if len < string.len(value) then 
      value=string.sub(value,1,len)
    end
    --newVal=string.sub(value,1,len)
    self["data"][id]=string.format("%s%"..(len-string.len(value)).."s",value,"")
end
function setFMSData(id,value)
    --print("setting " .. id .. " to "..value.." curently "..fmsModules["data"][id])
  
   fmsModules:setData(id,value)
end  
function getFMSData(id)
  if hasChild(fmsModules["data"],id) then
    return fmsModules["data"][id]
  end
  return fmsModules["data"][id]
end 
fmsModules["lastcmd"]=" "
fmsModules["cmds"]={}
fmsModules["cmdstrings"]={}
function registerFMCCommand(commandID,dataString)
  fmsModules["cmds"][commandID]=find_command(commandID)
  fmsModules["cmdstrings"][commandID]=dataString
end

function switchCustomMode()
  fmsModules["fmsL"]["inCustomFMC"]=fmsModules["fmsL"]["targetCustomFMC"]
  fmsModules["fmsC"]["inCustomFMC"]=fmsModules["fmsC"]["targetCustomFMC"]
  fmsModules["fmsR"]["inCustomFMC"]=fmsModules["fmsR"]["targetCustomFMC"]
  fmsModules["fmsL"]["currentPage"]=fmsModules["fmsL"]["targetPage"]
  fmsModules["fmsC"]["currentPage"]=fmsModules["fmsC"]["targetPage"]
  fmsModules["fmsR"]["currentPage"]=fmsModules["fmsR"]["targetPage"]
  fmsModules["fmsL"]["pgNo"]=fmsModules["fmsL"]["targetpgNo"]
  fmsModules["fmsC"]["pgNo"]=fmsModules["fmsC"]["targetpgNo"]
  fmsModules["fmsR"]["pgNo"]=fmsModules["fmsR"]["targetpgNo"]
end
function createPage(page)
  retVal={}
  retVal.name=page
  retVal.template={
  "    " .. page,
  "                        ",
  "                        ",
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
  retVal.templateSmall={
  "                        ",
  "                        ",
  "                        ",
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
  retVal.getPage=function(self,pgNo) return self.template end
  retVal.getSmallPage=function(self,pgNo) return self.templateSmall end
  retVal.getNumPages=function(self) return 1 end
  fmsFunctionsDefs[page]={}
  return retVal
end
dofile("B744.notifications.lua")
dofile("irs/irs_system.lua")
dofile("B744.fms.pages.lua")

dofile("irs/rnav_system.lua")
dofile("B744.createfms.lua")

fmsC = {}
setmetatable(fmsC, {__index = fms})
fmsC.id="fmsC"
setDREFs(fmsC,"cdu1","fms1","sim/FMS/","fms3")
fmsC.inCustomFMC=true
fmsC.targetCustomFMC=true
fmsC.currentPage="INDEX"
fmsC.targetPage="INDEX"

fmsL = {}
setmetatable(fmsL, {__index = fms})
fmsL.id="fmsL"
setDREFs(fmsL,"cdu1","fms3","sim/FMS/","fms1")
fmsL.inCustomFMC=true
fmsL.targetCustomFMC=true
fmsL.currentPage="INDEX"
fmsL.targetPage="INDEX"

fmsR = {}
setmetatable(fmsR, {__index = fms})
fmsR.id="fmsR"
setDREFs(fmsR,"cdu2","fms2","sim/FMS2/","fms2")
fmsR.inCustomFMC=true
fmsR.targetCustomFMC=true
fmsR.currentPage="INDEX"
fmsR.targetPage="INDEX"

fmsModules.fmsL=fmsL;
fmsModules.fmsC=fmsC;
fmsModules.fmsR=fmsR;


B747DR_CAS_memo_status          = find_dataref("laminar/B747/CAS/memo_status")

function getCurrentWayPoint(fms)

	for i=1,table.getn(fms),1 do
    --print("FMS j="..fmsJSON)

		if fms[i][10] == true then
				--print("Found TRUE = "..fms[i][1].." "..fms[i][2].." "..fms[i][8])
				if fms[i][8] == "latlon" then
					return simDR_navID, fms[i][5], fms[i][6]
				else
					return fms[i][8], fms[i][5], fms[i][6]
				end
		end		
	end
	return ""  --NOT FOUND
end

function waypoint_eta_display()
	local hours = 0
	local mins = 0
	local secs = 0
	local default_speed = 275
	local actual_speed = simDR_ND_speed
	local time_to_waypoint = 0
	local fms = {}
	local fms_current_waypoint = ""
	local fms_latitude = ""
	local fms_longitude = ""
	local fms_distance_to_waypoint = 0
	
	if simDR_onGround ~= 1 and string.len(fmsJSON) > 2 then
		--print(fmsJSON)
		fms = json.decode(fmsJSON)	
		fms_current_waypoint, fms_latitude, fms_longitude = getCurrentWayPoint(fms)
		--print(string.match(fms_current_waypoint, "%("))
		if fms_current_waypoint ~= "" and fms_current_waypoint ~= "VECTOR" and not string.match(fms_current_waypoint, "%(") then
			--print("Checking distance for waypoint = "..fms_current_waypoint)
			fms_distance_to_waypoint = getDistance(simDR_latitude, simDR_longitude, fms_latitude, fms_longitude)
	
			time_to_waypoint = (fms_distance_to_waypoint / math.max(default_speed, actual_speed)) * 3600
			
			hours = math.floor((time_to_waypoint % 86400) / 3600)
			mins = math.floor((time_to_waypoint % 3600) / 60)
			secs = (time_to_waypoint % 60) / 60

			--Add to current Zulu time
			hours = hours + hh
			mins = mins + mm
			secs = secs + (ss / 60)
			
			if hours >= 24 then
				hours = hours - 24
			end
				
			if mins >= 60 then
				mins = mins - 60
				hours = hours + 1
			end
			
			if secs >= 1 then
				secs = secs - 1
				mins = mins + 1
			end
		end
	end
	
	if fms_current_waypoint == "" or string.match(fms_current_waypoint, "%(") then
		B747DR_ND_current_waypoint = ""
		B747DR_ND_waypoint_distance = "------NM"
		B747DR_ND_waypoint_eta = "------Z"	
	elseif fms_current_waypoint == "VECTOR" then
		B747DR_ND_current_waypoint = fms_current_waypoint
		B747DR_ND_waypoint_distance = "------NM"
		B747DR_ND_waypoint_eta = "------Z"
	else
		B747DR_ND_current_waypoint = fms_current_waypoint
		B747DR_ND_waypoint_distance = string.format("%5.1f".."nm", fms_distance_to_waypoint)
		B747DR_ND_waypoint_eta = string.format("%02d%02d.%d".."z", hours, mins, secs * 10)			
	end
end

function nd_range_display ()
	local range = {5, 10, 20, 40, 80, 160, 320}
			
	B747DR_ND_range_display_capt	= range[simDR_range_dial_capt + 1]
	B747DR_ND_range_display_fo		= range[simDR_range_dial_fo + 1]
end

function flight_start()
  if simDR_startup_running == 0 then
    irsSystem["irsL"]["aligned"]=false
    irsSystem["irsC"]["aligned"]=false
    irsSystem["irsR"]["aligned"]=false
    -- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then
      irsSystem["setPos"]=true
      irsSystem.align("irsL",true)
  
      irsSystem.align("irsC",true)
  
      irsSystem.align("irsR",true)
      
    end
 
	--Display Waypoint ETA on ND
	run_at_interval(waypoint_eta_display, 0.5)
end

debug_fms     = deferred_dataref("laminar/B747/debug/fms", "number")
fms_style = find_dataref("sim/cockpit2/radios/indicators/fms_cdu1_style_line2")
lastNotify=0
function setNotifications()
  local diff=simDRTime-lastNotify
  if diff<10 then return end
  --print("FMS notify")
  lastNotify=simDRTime
  for i =1,53,1 do
    --print("do FMS notify".." ".. i .." " ..B747DR_fmc_notifications[i])
    if B747DR_fmc_notifications[i]>0 then
      fmsModules["fmsL"]["notify"]=B747_FMCAlertMsg[i].name
      fmsModules["fmsC"]["notify"]=B747_FMCAlertMsg[i].name
      fmsModules["fmsR"]["notify"]=B747_FMCAlertMsg[i].name
      print("do FMS notify"..B747_FMCAlertMsg[i].name)
      break
    else
      if fmsModules["fmsL"]["notify"]==B747_FMCAlertMsg[i].name then fmsModules["fmsL"]["notify"]="" end
      if fmsModules["fmsC"]["notify"]==B747_FMCAlertMsg[i].name then fmsModules["fmsC"]["notify"]="" end
      if fmsModules["fmsR"]["notify"]==B747_FMCAlertMsg[i].name then fmsModules["fmsR"]["notify"]="" end
    end
  end

end
function after_physics()
  if debug_fms>0 then return end
--     for i =1,24,1 do
--       print(string.byte(fms_style,i))
--     end
    setNotifications()
    B747DR_FMSdata=json.encode(fmsModules["data"]["values"])--make the fms data available to other modules
    --print(B747DR_FMSdata)
    fmsL:B747_fms_display()
    fmsC:B747_fms_display()
    fmsR:B747_fms_display()
    if simDR_bus_volts[0]>24 then
      irsSystem.update()
      B747_setNAVRAD()
    end
    if acarsSystem.provider.online() then
      B747DR_CAS_memo_status[40]=0 --for CAS
      acars=1 --for radio
      acarsSystem.provider.receive()
      local hasNew=0
      for i = table.getn(acarsSystem.messages.values), 1, -1 do
		if not acarsSystem.messages[i]["read"] then 
			hasNew=1
		end 
      end 
      B747DR_CAS_memo_status[0]=hasNew
    else
      
      if B747DR_rtp_C_off==0 then
		B747DR_CAS_memo_status[40]=1 --for CAS
      else
		B747DR_CAS_memo_status[40]=0
      end
      acars=0 --for radio
    end
	
	--SET FUEL WEIGHT UNITS
	B747DR_fuel_display_units = getFMSData("fuelUnits")
	if B747DR_fuel_display_units == "LBS" then
		B747DR_fuel_display_units_eicas = 1
	else
		B747DR_fuel_display_units_eicas = 0
	end

	--Display range NM on ND
	nd_range_display ()
end
