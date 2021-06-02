--[[
****************************************************************************************
* Program Script Name	:	B747.42.xt.EEC.lua
* Author Name			:	Marauder28
*							(with SIGNIFICANT contributions from @kudosi for aeronautic formulas)
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2021-01-11	0.01a				Start of Dev
*	2021-05-27	0.1					Initial Release
*
*
*
*****************************************************************************************
]]

--Load helper files
dofile("json/json.lua")
dofile("B747.42.xt.EEC.tbls.lua")


--[[
*************************************************************************************
** 				              MISC FUNCTIONS              		    	           **
*************************************************************************************
]]
function deferred_dataref(name,nilType,callFunction)
    if callFunction~=nil then
        print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end

function B747_rescale(in1, out1, in2, out2, x)
    if x < in1 then
        return out1
    end
    if x > in2 then
        return out2
    end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)
end

function round_thrustcalc(x, input_type)
    --print("x IN = "..x)  
  
    if input_type == "ALT" then
      if x < -2000 then
        x = -2000
      elseif x > 10000 then
        x = 10000
      end
      --print("x Corrected = "..x)
      return x >= 0 and math.floor((x / 1000) + 0.5) * 1000 or math.ceil((x / 1000) - 0.5) * 1000  --Alts in 1000s
    elseif input_type == "ALT-CLB" then
      if x < 0 then
        x = 0
      elseif x > 45000 then
        x = 45000
      end
      print("x Corrected = "..x)
      return x >= 0 and math.floor((x / 5000) + 0.5) * 5000 or math.ceil((x / 5000) - 0.5) * 5000  --Alts in 5000s
    elseif input_type == "TEMP" then
  --    if x < 10 then
  --      x = 10
  --    elseif x > 70 then
  --      x = 70
  --    end
      --print("x Corrected = "..x)
      return x >= 0 and math.floor((x / 5) + 0.5) * 5 or math.ceil((x / 5) - 0.5) * 5  --Temps by 5's
    end
  end

  function find_closest_temperature(table_in, temp_target)
	local temp_table = {}
	local closest_match
	local last_difference = 99999999
	local counter = 1

	for i, v in pairs(table_in) do
		for i, v in pairs(v) do
			table.insert(temp_table, i)
		end
	end
	table.sort(temp_table)

	for i,v in pairs(temp_table) do
		local distance = math.abs(temp_target - v) --Distance away
		if distance < last_difference then
			closest_match = v
			last_difference = distance
		end
	end
	
	return closest_match
end

--[[
*************************************************************************************
** 				              FIND X-PLANE DATAREFS              		    	   **
*************************************************************************************
]]
simDR_EEC_button			= find_dataref("laminar/B747/button_switch/position")  --array positions 7,8,9,10
simDR_onGround				= find_dataref("sim/flightmodel/failures/onground_any")
simDR_altitude				= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
simDR_temperature			= find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")
simDR_TAT					= find_dataref("sim/cockpit2/temperature/outside_air_LE_temp_degc")
simDR_EPR					= find_dataref("sim/flightmodel/engine/ENGN_EPR")
simDR_EPR_target_bug		= find_dataref("sim/cockpit2/engine/actuators/EPR_target_bug")
simDR_N1					= find_dataref("sim/flightmodel/engine/ENGN_N1_")
--simDR_N1_rpm				= find_dataref("sim/cockpit2/engine/indicators/engine_speed_rpm")
simDR_N1_target_bug			= find_dataref("sim/cockpit2/engine/actuators/N1_target_bug")
simDR_throttle_ratio		= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio")
--simDR_throttle_ratio_all	= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")
--simDR_throttle_used_ratio	= find_dataref("sim/flightmodel2/engines/throttle_used_ratio")
simDR_override_throttles	= find_dataref("sim/operation/override/override_throttles")
simDR_engn_thro				= find_dataref("sim/flightmodel/engine/ENGN_thro")
simDR_engn_thro_use			= find_dataref("sim/flightmodel/engine/ENGN_thro_use")
simDR_throttle_max			= find_dataref("sim/aircraft/engine/acf_throtmax_FWD")
simDR_acf_weight_total_kg   = find_dataref("sim/flightmodel/weight/m_total")
simDR_ias_pilot				= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
simDR_vvi_fpm_pilot        	= find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
simDR_tas_pilot				= find_dataref("sim/cockpit2/gauges/indicators/true_airspeed_kts_pilot")
--simDR_flap_Cd				= find_dataref("sim/aircraft/controls/acf_flap_cd")
--simDR_flap_Cl				= find_dataref("sim/aircraft/controls/acf_flap_cl")
simDR_flap_ratio			= find_dataref("sim/cockpit2/controls/flap_ratio")
simDR_flap_handle_ratio		= find_dataref("sim/cockpit2/controls/flap_handle_deploy_ratio")
simDR_thrust_max			= find_dataref("sim/aircraft/engine/acf_tmax")
simDR_thrust_n				= find_dataref("sim/cockpit2/engine/indicators/thrust_dry_n")
simDR_engine_anti_ice		= find_dataref("laminar/B747/antiice/nacelle/valve_pos")
--simDR_engine_sigma			= find_dataref("sim/flightmodel/engine/ENGN_sigma")
simDR_autopilot_gs_status	= find_dataref("sim/cockpit2/autopilot/glideslope_status")
simDR_acceleration_kts_sec_pilot    = find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot")
--simDR_override_engn_ff		= find_dataref("sim/operation/override/override_fuel_flow")
--simDR_engn_ff_kgs			= find_dataref("sim/flightmodel/engine/ENGN_FF_")
simDR_engn_EGT_c			= find_dataref("sim/flightmodel/engine/ENGN_EGT_c")
simDR_engine_high_idle_ratio	= find_dataref("sim/aircraft2/engine/high_idle_ratio")

--[[
*************************************************************************************
** 				              FIND X-PLANE COMMANDS              		    	   **
*************************************************************************************
]]
simCMD_autopilot_AT_off		= find_command("sim/autopilot/autothrottle_off")
simCMD_ThrottleUp			= find_command("sim/engines/throttle_up")

--[[
*************************************************************************************
** 				              CUSTOM READ/WRITE DATAREFS           		    	   **
*************************************************************************************
]]
B747DR_packs 					= deferred_dataref("laminar/B747/air/pack_ctrl/sel_dial_pos", "array[3]")
B747DR_TO_throttle				= deferred_dataref("laminar/B747/engines/thrustref_throttle", "number")
B747DR_ap_FMA_autothrottle_mode	= deferred_dataref("laminar/B747/autopilot/FMA/autothrottle_mode", "number")
--[[
    0 = NONE
    1 = HOLD
    2 = IDLE
    3 = SPD
    4 = THR
    5 = THR REF
--]]
B747DR_ap_autothrottle_armed	= deferred_dataref("laminar/B747/autothrottle/armed", "number")
B747DR_engine_TOGA_mode			= deferred_dataref("laminar/B747/engines/TOGA_mode", "number")
--B747DR_ap_FMA_autothrottle_mode_box_status  = deferred_dataref("laminar/B747/autopilot/FMA/autothrottle/mode_box_status", "number")
B747DR_ref_thr_limit_mode		= deferred_dataref("laminar/B747/engines/ref_thr_limit_mode", "string")
--[[
    ["NONE"]
    ["TO"]
    ["TO 1"]
    ["TO 2"]
    ["D-TO"]
    ["D-TO 1"]
    ["D-TO 2"]
    ["CLB"]
    ["CLB 1"]
    ["CLB 2"]
    ["CRZ"]
    ["CON"]
    ["GA"]
]]
B747DR_ap_FMA_active_pitch_mode     	= deferred_dataref("laminar/B747/autopilot/FMA/active_pitch_mode", "number")
--[[
    0 = NONE
    1 = TOGA
    2 = G/S
    3 = FLARE
    4 = VNAV SPD
    5 = VNAV ALT
    6 = VNAV PATH
    7 = V/S
    8 = FLCH SPD
    9 = ALT
--]]
B747DR_ap_ias_bug_value            	= deferred_dataref("laminar/B747/autopilot/ias_bug_value", "number")
B747DR_display_N1					= deferred_dataref("laminar/B747/engines/display_N1", "array[4]")
B747DR_display_N1_ref				= deferred_dataref("laminar/B747/engines/display_N1_ref", "array[4]")
B747DR_display_N1_max				= deferred_dataref("laminar/B747/engines/display_N1_max", "array[4]")
B747DR_display_EPR					= deferred_dataref("laminar/B747/engines/display_EPR", "array[4]")
B747DR_FMSdata						= deferred_dataref("laminar/B747/fms/data", "string")
B747DR_radio_altitude				= deferred_dataref("laminar/B747/efis/radio_altitude")
B747DR_altitude_dial				= deferred_dataref("laminar/B747/autopilot/heading/altitude_dial_ft")

B747DR_toderate						= deferred_dataref("laminar/B747/engine/derate/TO","number")
B747DR_clbderate					= deferred_dataref("laminar/B747/engine/derate/CLB","number")

-- Holds all SimConfig options
B747DR_simconfig_data				= deferred_dataref("laminar/B747/simconfig", "string")

--FMS data
B747DR_FMSdata						= deferred_dataref("laminar/B747/fms/data", "string")


--[[
*************************************************************************************
** 				              GLOBAL VARIABLES           		    	 		   **
*************************************************************************************
]]
--Constants
lbf_to_N = 4.4482216
mtrs_per_sec = 1.94384

--Logging On/Off
enable_logging = false  --true / false

--Simulator Config Options
simConfigData = {}

--FMS data
fmsModules = {}
fms_data = {}
fmc_alt = 0

--Atmosphere
altitude_ft = 0.0 --simDR_altitude
altitude_mtrs = 0.0 --altitude_ft * 0.3048
pressure_pa = 0.0  --pascals
pressure_ratio = 0.0
density = 0.0  --kg per m^3
temperature_K = 0.0  --kelvin
temperature_C = 0.0  --celcius
corner_temperature_K = 0.0  --kelvin
temperature_ratio = 0.0
temperature_ratio_adapted = 0.0
speed_of_sound = 0.0  --mtrs per sec

--Flight Coefficients
mach = 0.0
cL = 0.0
cD = 0.0
--climb_angle_deg = 0.0
tas_mtrs_sec = 0.0
--acceleration_kts_sec = simDR_acceleration_kts_sec_pilot / 1.94384
--acceleration_mtrs_sec = 0.0  --mtrs per sec^2

--EEC Status Flag
EEC_status = 0

--General Engine Parameters
engine_max_thrust_n = 0

--[[
*************************************************************************************
** 				              LOCAL VARIABLES           		    	 		   **
*************************************************************************************
]]


--[[
*************************************************************************************
** 				              GLOBAL CODE                  		    	 		   **
*************************************************************************************
]]
if string.len(B747DR_simconfig_data) > 1 then
	simConfigData["data"] = json.decode(B747DR_simconfig_data)
else
	simConfigData["data"] = json.decode("[]")
end

if string.len(B747DR_FMSdata) > 1 then
	fmsModules["data"] = json.decode(B747DR_FMSdata)
else
	fmsModules["data"] = json.decode("[]")
end

--[[
*************************************************************************************
** 				              AERODYNAMIC FUNCTIONS (GLOBAL)	    	           **
*************************************************************************************
]]
function atmosphere(altitude_ft_in, delta_t_isa_K_in)
    local altitude_mtrs = altitude_ft_in * 0.3048

    if altitude_mtrs < 11000 then
        pressure_pa = (1-0.00651 * altitude_mtrs / 288.15)^5.255 * 101325
        temperature_K = 288.15 - 6.5 / 1000 * altitude_mtrs
    else
        pressure_pa = 22632 * 2.71828^(-9.81 * (altitude_mtrs - 11000) / (287 *216.65))
        temperature_K = 216.65
    end


    pressure_ratio = pressure_pa / 101325
    density = pressure_pa / (287 * temperature_K)
    temperature_C = temperature_K - 273.15
    corner_temperature_K = 7.31E-12 * altitude_ft_in^3 - 7.73E-08 * altitude_ft_in^2 - 0.00216 * altitude_ft_in + 305
    temperature_ratio = (temperature_K + delta_t_isa_K_in) / 288.15
    temperature_ratio_adapted = (temperature_K + delta_t_isa_K_in + 5) / 288.15
    speed_of_sound = math.sqrt(287 * 1.4 * temperature_K)

    if enable_logging then
		print("\t\t\t\t\t<<<--- ATMOSPHERE --->>>")
		print("Altitude IN = ", altitude_ft_in)
		print("Delta T ISA K IN = ", delta_t_isa_K_in)
		print("Altitude MTRS = ", altitude_mtrs)
		print("Pressure PA = ", pressure_pa)
		print("Pressure Ratio = ", pressure_ratio)
		print("Density = ", density)
		print("Temperature K = ", temperature_K)
		print("Temperature C = ", temperature_C)
		print("Corner Temperature K = ", corner_temperature_K)
		print("Temperature Ratio = ", temperature_ratio)
		print("Temperature Ratio Adapted = ", temperature_ratio_adapted)
		print("Speed of Sound = ", speed_of_sound)
    --print("\n")
	end

    --return altitude_mtrs, pressure_pa, pressure_ratio, density, temperature_K, temperature_C, corner_temperature_K, temperature_ratio, temperature_ratio_adapted, speed_of_sound
end

function flight_coefficients(gw_kg_in, tas_kts_in)
	local flaps_incremental_drag = 0.0

	if tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.0 then
		flaps_incremental_drag = 0.0
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.167 then  --Flaps 1
		flaps_incremental_drag = 0.008
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.333 then  --Flaps 5
		flaps_incremental_drag = 0.018
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.5 then  --Flaps 10
		flaps_incremental_drag = 0.018
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.667 then  --Flaps 20
		flaps_incremental_drag = 0.028
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 0.833 then  --Flaps 25 & Gear Down
		flaps_incremental_drag = 0.088
	elseif tonumber(string.format("%4.3f", simDR_flap_ratio)) == 1.0 then  --Flaps 30  & Gear Down
		flaps_incremental_drag = 0.108
	end

	tas_mtrs_sec = tas_kts_in / mtrs_per_sec
    mach = tas_mtrs_sec / speed_of_sound
    cL = (gw_kg_in * 9.81) / (0.5 * density * tas_mtrs_sec^2 * 511)

    if mach > 0.7 then
        cD = -1.881 + 7.115 * mach + 0.5293 * cL - 8.928 * mach^2 -1.091 * mach * cL -0.2917 * cL^2 +3.746 * mach^3 + 0.5522 * mach^2 * cL + 0.3291 * mach * cL^2 + 0.1029 * cL^3 + flaps_incremental_drag
    else
        cD = 0.106 * cL^2 - 0.0463 * cL + 0.0219 + flaps_incremental_drag
    end

    --climb_angle_deg = math.asin(0.00508 * climb_rate_fpm_in / tas_mtrs_sec) * 180 / math.pi
    --acceleration_mtrs_sec = acceleration_kts_sec_in / 1.94384

	if enable_logging then
		print("\t\t\t\t\t<<<--- FLIGHT COEFFICIENTS --->>>")
		print("Gross Weight IN = ", gw_kg_in)
		--print("Climb Rate FPM IN = ", climb_rate_fpm_in)
		--print("Acceleration KTS SEC IN = ", acceleration_kts_sec_in)
		print("Mach = ", mach)
		print("Coefficient of Lift = ", cL)
		print("Coefficient of Drag = ", cD)
		print("Flap Handle = ", simDR_flap_ratio)
		print("Flaps Incremental Drag = ", flaps_incremental_drag)
		--print("Climb Angle Degrees = ", climb_angle_deg)
		print("TAS MTRS Sec = ", tas_mtrs_sec)
		--print("Acceleration MTRS Sec = ", acceleration_mtrs_sec)
		--print("\n")
	end

    --return mach, cL, cD, climb_angle_deg, tas_mtrs_sec, acceleration_mtrs_sec
	--return mach, cL, cD, tas_mtrs_sec
end


--[[
*************************************************************************************
** 				              EEC FUNCTIONS              		    	           **
*************************************************************************************
]]
function clear_thrust_targets()
	-- Clear Thrust Target Bugs
	for i = 0, 8 do
		simDR_EPR_target_bug[i] = 0.0
		simDR_N1_target_bug[i] = 0.0
	end
end

local previous_altitude = 0
function throttle_management()
	--local fms_data = {}
	--local fmc_alt = 0

	--Get FMC data for CRZ ALT
	if string.len(B747DR_FMSdata) > 2 then
		fms_data["data"] = json.decode(B747DR_FMSdata)
	else
		return
	end

	--Disconnect A/T if any of the EEC buttons move from NORMAL to ALTERNATE
	if (simDR_EEC_button[7] == 0 or simDR_EEC_button[8] == 0 or simDR_EEC_button[9] == 0 or simDR_EEC_button[10] == 0) and EEC_status == 0 then
		simCMD_autopilot_AT_off:once()
		EEC_status = 1
	elseif (simDR_EEC_button[7] == 1 and simDR_EEC_button[8] == 1 and simDR_EEC_button[9] == 1 and simDR_EEC_button[10] == 1) then
		EEC_status = 0
	end
	
	if string.match(fms_data["data"].crzalt, "FL") then
		fmc_alt = tonumber(string.sub(fms_data["data"].crzalt, 3,-1)) * 100
	elseif string.match(fms_data["data"].crzalt, "*") then
		fmc_alt = 0
	else
		fmc_alt = tonumber(fms_data["data"].crzalt)
	end
	
	if enable_logging then
		print("EEC Status = ", EEC_status)
		print("FMC CRZ ALT = ", fms_data["data"].crzalt)
		print("temp FMC ALT = ", fmc_alt)
	end

	--Set EICAS Thrust Limit Mode
	--Take-off
	if B747DR_engine_TOGA_mode > 0 and B747DR_engine_TOGA_mode <= 1 then
		B747DR_ref_thr_limit_mode = "TO"

		--Initially set previous_altitude to the FMC cruise altitude
		previous_altitude = fmc_alt

		--Spool-up the engines for TO
		if B747DR_display_N1[0] < B747DR_display_N1_ref[0] or B747DR_display_N1[1] < B747DR_display_N1_ref[1]
			or B747DR_display_N1[2] < B747DR_display_N1_ref[2] or B747DR_display_N1[3] < B747DR_display_N1_ref[3] then
			print("TOGA Engaged - Waiting for spool-up.....")
			simCMD_ThrottleUp:once()
			return
		end
	--Set Initial Climb based on Flap position (5 degrees) if occurs prior to FMC thrust reduction point
	elseif simDR_onGround ~= 1 and ((simDR_flap_ratio < 0.34 and simDR_flap_handle_ratio > simDR_flap_ratio) or (string.match(B747DR_ref_thr_limit_mode, "TO") and B747DR_radio_altitude >= 1500 )) then
		B747DR_ref_thr_limit_mode = "CLB"
	--Cruise
	elseif simDR_onGround ~= 1 and simDR_altitude >= (fmc_alt - 250) and fmc_alt > 0 then
		B747DR_ref_thr_limit_mode = "CRZ"
		--Reset local previous_altitude holder
		if B747DR_altitude_dial < previous_altitude then
			previous_altitude = B747DR_altitude_dial
		else
			previous_altitude = fmc_alt
		end

		if enable_logging then
			print("Previous ALT = ", previous_altitude)
		end
	--Go-Around
	elseif simDR_onGround ~= 1 and (simDR_flap_ratio > 0.0 and simDR_flap_handle_ratio < simDR_flap_ratio) or simDR_autopilot_gs_status == 2 then
		B747DR_ref_thr_limit_mode = "GA"
	--Climb
	elseif simDR_onGround ~= 1 and (previous_altitude < B747DR_altitude_dial) and B747DR_ap_FMA_autothrottle_mode == 5 then
		B747DR_ref_thr_limit_mode = "CLB"
	end

	--Remove De-rate above 15000 feet
	if B747DR_clbderate > 0 and simDR_altitude >= 15000 then
		B747DR_clbderate = 0
	end
	
	--Set Specific sub-mode for TO or CLB
	if string.match(B747DR_ref_thr_limit_mode, "TO") then
		if B747DR_toderate == 0 then
			B747DR_ref_thr_limit_mode = "TO"
		elseif B747DR_toderate == 1 then
			B747DR_ref_thr_limit_mode = "TO 1"
		elseif B747DR_toderate == 2 then
			B747DR_ref_thr_limit_mode = "TO 2"
		end
	elseif string.match(B747DR_ref_thr_limit_mode, "CLB") then
		if B747DR_clbderate == 0 then
			B747DR_ref_thr_limit_mode = "CLB"
		elseif B747DR_clbderate == 1 then
			B747DR_ref_thr_limit_mode = "CLB 1"
		elseif B747DR_clbderate == 2 then
			B747DR_ref_thr_limit_mode = "CLB 2"
		end
	end


	--Determine FMA Mode
	--TO (TOGA)
	--THR REF Mode
	if B747DR_ap_autothrottle_armed == 1 and B747DR_ap_FMA_autothrottle_mode == 5 and EEC_status == 0 then
		--Take control of the throttles from the user and manage via Thrust Ref targets
		--hold_mode = 0
		if B747DR_ap_FMA_active_pitch_mode == 1 or B747DR_ap_FMA_active_pitch_mode == 4
		or B747DR_ap_FMA_active_pitch_mode == 5 or B747DR_ap_FMA_active_pitch_mode == 6 then
			simDR_override_throttles = 1
		end
		
		if enable_logging then
			print("THR REF MODE")
			print("Override Throttles = ", simDR_override_throttles)
		end

	-- HOLD Mode
	elseif B747DR_ap_autothrottle_armed == 1 and B747DR_ap_FMA_autothrottle_mode == 1 and EEC_status == 0 then
		--Give throttle control back to the user
		simDR_override_throttles = 0
		--hold_mode = 1

		if enable_logging then
			print("HOLD MODE")
			print("Override REMOVED = ", simDR_override_throttles)
		end

	--SPEED Mode
	elseif B747DR_ap_autothrottle_armed == 1 and B747DR_ap_FMA_autothrottle_mode == 3 and EEC_status == 0 then
		--Give throttle control back to the user
		--hold_mode = 0
		simDR_override_throttles = 0
		--speed_mode = 1
		
		if enable_logging then
			print("SPEED MODE")
			print("Override Throttles = ", simDR_override_throttles)
		end
	else
		simDR_override_throttles = 0
		--hold_mode = 0
		--speed_mode = 0

		if enable_logging then
			print("---Setting Back to Normal---")
		end
	end
end

dofile("B747.42.xt.EEC.GE.lua")
dofile("B747.42.xt.EEC.PW.lua")
dofile("B747.42.xt.EEC.RR.lua")

function set_engines()
	--Engine Thrust Parameters based on selected engine
	if string.match(simConfigData["data"].PLANE.engines, "CF6") then
		GE(simDR_altitude)
	elseif string.match(simConfigData["data"].PLANE.engines, "PW") then
		PW(simDR_altitude)
	elseif string.match(simConfigData["data"].PLANE.engines, "RB") then
		RR(simDR_altitude)
	end
end


--[[
*************************************************************************************
** 				              XP CALLBACKS              		    	           **
*************************************************************************************
]]
function aircraft_load()
	clear_thrust_targets()  --Set all thrust target bugs to 0
end

function after_physics()

    atmosphere(simDR_altitude, 0)
    flight_coefficients(simDR_acf_weight_total_kg, simDR_tas_pilot)

    --Ensure simConfig data is fresh
	simConfigData["data"] = json.decode(B747DR_simconfig_data)

	--fmsModules["data"] = json.decode(B747DR_FMSdata)
	
	if string.len(B747DR_simconfig_data) > 1 then
		set_engines()
	end

end