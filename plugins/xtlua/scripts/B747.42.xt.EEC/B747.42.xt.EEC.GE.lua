--[[
****************************************************************************************
* Program Script Name	:	B747.42.xt.EEC.GE.lua
* Author Name			:	Marauder28
*                   (with SIGNIFICANT contributions from @kudosi for aeronautic formulas)
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2021-01-11	0.01a				      Start of Dev
*	  2021-05-27	0.1					      Initial Release
*
*
*
*****************************************************************************************
]]

function thrust_ref_control_N1()
	local throttle_move_units = 0.001
	local target_tolerance_N1 = 0.5
	local tolerance_diff = {}

	--If Dataref updates aren't current, then wait for another cycle
	if simDR_engn_thro[0] == 0 or simDR_engn_thro[1] == 0 or simDR_engn_thro[2] == 0 or simDR_engn_thro[3] == 0
	or simDR_engn_thro_use[0] == 0 or simDR_engn_thro_use[1] == 0 or simDR_engn_thro_use[2] == 0 or simDR_engn_thro_use[3] == 0 then
		return
	end
	
	if simDR_override_throttles == 1 then
		
    --DECREASE adjustments
		if B747DR_display_N1[0] > (simDR_N1_target_bug[0]) then  -- + target_tolerance_N1) then
			tolerance_diff[0] = math.abs(simDR_N1_target_bug[0] + target_tolerance_N1 - B747DR_display_N1[0])
			if tolerance_diff[0] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[0] = simDR_engn_thro_use[0] - throttle_move_units
			simDR_throttle_ratio[0] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[0])
		end
		if B747DR_display_N1[1] > (simDR_N1_target_bug[1]) then  -- + target_tolerance_N1) then
			tolerance_diff[1] = math.abs(simDR_N1_target_bug[1] + target_tolerance_N1 - B747DR_display_N1[1])
			if tolerance_diff[1] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[1] = simDR_engn_thro_use[1] - throttle_move_units
			simDR_throttle_ratio[1] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[1])
		end
		if B747DR_display_N1[2] > (simDR_N1_target_bug[2]) then  -- + target_tolerance_N1) then
			tolerance_diff[2] = math.abs(simDR_N1_target_bug[2] + target_tolerance_N1 - B747DR_display_N1[2])
			if tolerance_diff[2] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[2] = simDR_engn_thro_use[2] - throttle_move_units
			simDR_throttle_ratio[2] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[2])
		end
		if B747DR_display_N1[3] > (simDR_N1_target_bug[3]) then  -- + target_tolerance_N1) then
			tolerance_diff[3] = math.abs(simDR_N1_target_bug[3] + target_tolerance_N1 - B747DR_display_N1[3])
			if tolerance_diff[3] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[3] = simDR_engn_thro_use[3] - throttle_move_units
			simDR_throttle_ratio[3] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[3])
		end

		--INCREASE adjustments
		--if (B747DR_display_N1[0] < (simDR_N1_target_bug[0] - target_tolerance_N1)) and (simDR_thrust_n[0] < engine_max_thrust_n) then
    if (B747DR_display_N1[0] < simDR_N1_target_bug[0]) and (simDR_thrust_n[0] < engine_max_thrust_n) then
			tolerance_diff[0] = math.abs(simDR_N1_target_bug[0] - target_tolerance_N1 - B747DR_display_N1[0])
			if tolerance_diff[0] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[0] = simDR_engn_thro_use[0] + throttle_move_units
			if simDR_engn_thro_use[0] >= simDR_throttle_max then
				print("RESETTING THROTTLE TO MAX = 1")
				simDR_engn_thro_use[0] = simDR_throttle_max 
			end
			simDR_throttle_ratio[0] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[0])
		end
		--if (B747DR_display_N1[1] < (simDR_N1_target_bug[1] - target_tolerance_N1)) and (simDR_thrust_n[1] < engine_max_thrust_n) then
    if (B747DR_display_N1[1] < simDR_N1_target_bug[1]) and (simDR_thrust_n[1] < engine_max_thrust_n) then
			tolerance_diff[1] = math.abs(simDR_N1_target_bug[1] - target_tolerance_N1 - B747DR_display_N1[1])
			if tolerance_diff[1] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[1] = simDR_engn_thro_use[1] + throttle_move_units
			if simDR_engn_thro_use[1] >= simDR_throttle_max then
				simDR_engn_thro_use[1] = simDR_throttle_max 
			end
			simDR_throttle_ratio[1] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[1])
		end
		--if (B747DR_display_N1[2] < (simDR_N1_target_bug[2] - target_tolerance_N1)) and (simDR_thrust_n[2] < engine_max_thrust_n) then
    if (B747DR_display_N1[2] < simDR_N1_target_bug[2]) and (simDR_thrust_n[2] < engine_max_thrust_n) then
			tolerance_diff[2] = math.abs(simDR_N1_target_bug[2] - target_tolerance_N1 - B747DR_display_N1[2])
			if tolerance_diff[2] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[2] = simDR_engn_thro_use[2] + throttle_move_units
			if simDR_engn_thro_use[2] >= simDR_throttle_max then
				simDR_engn_thro_use[2] = simDR_throttle_max
			end
			simDR_throttle_ratio[2] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[2])
		end
		--if (B747DR_display_N1[3] < (simDR_N1_target_bug[3] - target_tolerance_N1)) and (simDR_thrust_n[3] < engine_max_thrust_n) then
    if (B747DR_display_N1[3] < simDR_N1_target_bug[3]) and (simDR_thrust_n[3] < engine_max_thrust_n) then
			tolerance_diff[3] = math.abs(simDR_N1_target_bug[3] - target_tolerance_N1 - B747DR_display_N1[3])
			if tolerance_diff[3] <= target_tolerance_N1 then
				throttle_move_units = 0.0001
			else
				throttle_move_units = 0.001
			end
			simDR_engn_thro_use[3] = simDR_engn_thro_use[3] + throttle_move_units
			if simDR_engn_thro_use[3] >= simDR_throttle_max then
				simDR_engn_thro_use[3] = simDR_throttle_max 
			end
			simDR_throttle_ratio[3] = B747_rescale(0.0, 0.0, simDR_throttle_max, 1.0, simDR_engn_thro_use[3])
		end
	end
end

--[[function take_off_thrust_assumed(altitude_ft_in, temperature_K_in)
  local TOGA_corrected_thrust_lbf = 0.0
  local TOGA_actual_thrust_lbf = 0.0
  local TOGA_actual_thrust_N = 0.0
  local approximate_max_TO_thrust_lbf = 0
  local temperature_K = 0.0

  temperature_K = fmsModules["data"]["thrustsel"] + 274.15

  if temperature_K_in > corner_temperature_K then
      TOGA_corrected_thrust_lbf = (-1.79545 * (temperature_K / corner_temperature_K) + 2.7874) * (-0.0000546 * altitude_ft_in^2 + 1.37 * altitude_ft_in + approximate_max_TO_thrust_lbf)
  else
      TOGA_corrected_thrust_lbf = (-0.0000546 * altitude_ft_in^2 + 1.37 * altitude_ft_in + approximate_max_TO_thrust_lbf)
  end

  TOGA_actual_thrust_lbf = TOGA_corrected_thrust_lbf * pressure_ratio
  TOGA_actual_thrust_N = TOGA_actual_thrust_lbf * lbf_to_N

  if enable_logging then
    print("\t\t\t\t\t<<<--- Assumed Temp Takeoff Calcs --->>>")
    print("Altitude IN = ", altitude_ft_in)
    print("Temperature K IN = ", temperature_K_in)
    print("Approximate Takeoff Thrust Required = ", approximate_max_TO_thrust_lbf)
    print("TOGA Corrected LBF = ", TOGA_corrected_thrust_lbf)
    print("TOGA Actual LBF = ", TOGA_actual_thrust_lbf)
    print("TOGA Actual N = ", TOGA_actual_thrust_N)
  end

  return TOGA_corrected_thrust_lbf  --, TOGA_actual_thrust_lbf, TOGA_actual_thrust_N
end]]

function take_off_thrust_corrected(altitude_ft_in, temperature_K_in)
  local TOGA_corrected_thrust_lbf = 0.0
  local TOGA_actual_thrust_lbf = 0.0
  local TOGA_actual_thrust_N = 0.0
  local approximate_max_TO_thrust_lbf = 0

  --Approximate TOGA Max thrust
  --  GE CFG-802C-B1F = 57160 lbf (Engine Max = 58000 lbf / 258000 Newtons)
  --  GE CFG-802C-B5F = 60030 lbf (Engine Max = 60800 lbf / 270500 Newtons)
  --  PW4056 = 56750 lbf (Engine Max = 56750 lbf / 252500 Newtons)
  --  PW4060 = 60000 lbf (Engine Max = 60000 lbf / 266900 Newtons)
  --  PW4062 = 62000 lbf (Engine Max = 62000 lbf / 275800 Newtons)
  --  RR RB211-524G = 56870 lbf (Engine Max = 58000 lbf / 258000 Newtons)
  --  RR RB211-524H = 59450 lbf (Engine Max = 60600 lbf / 269600 Newtons)
  if simConfigData["data"].PLANE.engines == "CF6-80C2-B1F" then
      approximate_max_TO_thrust_lbf = 57160
  elseif simConfigData["data"].PLANE.engines == "CF6-80C2-B5F" then
      approximate_max_TO_thrust_lbf = 60030
  elseif simConfigData["data"].PLANE.engines == "CF6-80C2-B1F1" then
    approximate_max_TO_thrust_lbf = 60030
  --elseif simConfigData["data"].PLANE.engines == "PW4056" then
  --    approximate_max_TO_thrust_lbf = 56750
  --elseif simConfigData["data"].PLANE.engines == "PW4060" then
  --    approximate_max_TO_thrust_lbf = 60000
  --elseif simConfigData["data"].PLANE.engines == "PW4062" then
  --    approximate_max_TO_thrust_lbf = 62000
  --elseif simConfigData["data"].PLANE.engines == "RB211-524G" then
  --    approximate_max_TO_thrust_lbf = 56870
  --elseif simConfigData["data"].PLANE.engines == "RB211-524H" then
  --    approximate_max_TO_thrust_lbf = 59450
  --else
  --    approximate_max_TO_thrust_lbf = 56500  --failsafe option
  end

  if temperature_K_in > corner_temperature_K then
      TOGA_corrected_thrust_lbf = (-1.79545 * (temperature_K_in / corner_temperature_K) + 2.7874) * (-0.0000546 * altitude_ft_in^2 + 1.37 * altitude_ft_in + approximate_max_TO_thrust_lbf)
  else
      TOGA_corrected_thrust_lbf = (-0.0000546 * altitude_ft_in^2 + 1.37 * altitude_ft_in + approximate_max_TO_thrust_lbf)
  end

  if B747DR_toderate == 1 then
    TOGA_corrected_thrust_lbf = TOGA_corrected_thrust_lbf * 0.9
  elseif B747DR_toderate == 2 then
    TOGA_corrected_thrust_lbf = TOGA_corrected_thrust_lbf * 0.8
  end

  TOGA_actual_thrust_lbf = TOGA_corrected_thrust_lbf * pressure_ratio
  TOGA_actual_thrust_N = TOGA_actual_thrust_lbf * lbf_to_N

  if enable_logging then
    print("\t\t\t\t\t<<<--- Takeoff Calcs --->>>")
    print("Altitude IN = ", altitude_ft_in)
    print("Temperature K IN = ", temperature_K_in)
    print("Approximate Takeoff Thrust Required = ", approximate_max_TO_thrust_lbf)
    print("TOGA Corrected LBF = ", TOGA_corrected_thrust_lbf)
    print("TOGA Actual LBF = ", TOGA_actual_thrust_lbf)
    print("TOGA Actual N = ", TOGA_actual_thrust_N)
  end

  return TOGA_corrected_thrust_lbf, TOGA_actual_thrust_lbf, TOGA_actual_thrust_N
end

function in_flight_thrust(gw_kg_in, climb_angle_deg_in)
  local total_thrust_required_N = 0.0
  local thrust_per_engine_N = 0.0
  local corrected_thrust_N = 0.0
  local corrected_thrust_lbf = 0.0

  total_thrust_required_N = 0.5 * cD * tas_mtrs_sec^2 * density * 511 + math.sin(climb_angle_deg_in / 180 * math.pi) * gw_kg_in * 9.81

  if B747DR_clbderate == 1 then
    total_thrust_required_N = total_thrust_required_N * B747_rescale(10000.0, 0.9, 15000.0, 1.0, simDR_altitude)  --0.9  --Scale linearly from CLB1 to CLB from 10K to 15K ft
  elseif B747DR_clbderate == 2 then
    total_thrust_required_N = total_thrust_required_N * B747_rescale(10000.0, 0.8, 15000.0, 1.0, simDR_altitude)  --0.8  --Scale linearly from CLB1 to CLB from 10K to 15K ft
  end

  thrust_per_engine_N = total_thrust_required_N / 4

  corrected_thrust_N = thrust_per_engine_N / pressure_ratio
  corrected_thrust_lbf = corrected_thrust_N / lbf_to_N

  if enable_logging then
    print("\t\t\t\t<<<--- IN FLIGHT THRUST --->>>")
    print("Gross Weight IN = ", gw_kg_in)
    print("Climb Angle IN = ", climb_angle_deg_in)
    print("Pressure Ratio = ", pressure_ratio)
    print("Density = ", density)
    print("Coefficient of Drag = ", cD)
    print("TAS MTRS Sec = ", tas_mtrs_sec)
    print("Total Thrust Required N = ", total_thrust_required_N)
    print("Thrust per Engine N = ", thrust_per_engine_N)
    print("Corrected Thrust N = ", corrected_thrust_N)
    print("Corrected Thrust LBF = ", corrected_thrust_lbf)
  end

  return total_thrust_required_N, thrust_per_engine_N, corrected_thrust_N, corrected_thrust_lbf
end

function take_off_N1_GE(altitude_ft_in)
  local N1_corrected = 0.0
  local N1_actual = 0.0
  local temperature_K = 0.0
  local temperature_ratio = 0.0

  --locals to hold returned values from take_off_thrust_corrected() function
  local TOGA_corrected_thrust_lbf = 0.0
  local TOGA_actual_thrust_N = 0.0

  --For Takeoff, use actual Sim temperature instead of atmosphere() temperature_K
  --If a derate temperature is entered in the THRUST LIM page of the FMC, use that instead
  --if fmsModules["data"]["thrustsel"] ~= "  " then
  --  temperature_K = tonumber(fmsModules["data"]["thrustsel"]) + 273.15
  --else
    temperature_K = simDR_temperature + 273.15
  --end

  temperature_ratio = temperature_K / 288.15

  --get take_off_thrust_corrected() data
  TOGA_corrected_thrust_lbf, _, TOGA_actual_thrust_N = take_off_thrust_corrected(altitude_ft_in, temperature_K)

  --Mach should always be 0 for purposes of this calculation
  mach = 0.0

  N1_corrected = (-1.4446E-12 * mach^2 + 1.2102E-12 * mach + 4.8911E-13) * TOGA_corrected_thrust_lbf^3 + (1.1197E-07 * mach^2 - 7.8717E-08 * mach - 6.498200000000002E-08)
                  * TOGA_corrected_thrust_lbf^2 + (-0.0027 * mach^2 + 0.0011 * mach + 0.0036) * TOGA_corrected_thrust_lbf + (36.93 * mach + 20.96)

  N1_actual = string.format("%4.1f", N1_corrected * math.sqrt(temperature_ratio))

  if enable_logging then
    print("\t\t\t\t\t<<<--- TAKEOFF N1 (GE) --->>>")
    print("Altitude IN = ", altitude_ft_in)
    print("Temperature K = ", temperature_K)
    print("Temperature Ratio = ", temperature_ratio)
    print("Mach = ", mach)
    print("TOGA Corrected Thrust = ", TOGA_corrected_thrust_lbf)
    print("N1 Corrected = ", N1_corrected)
    print("N1 Actual = ", N1_actual)
  end

  return N1_actual, TOGA_actual_thrust_N
end

function in_flight_N1_GE(altitude_ft_in, delta_t_isa_K_in)
    local N1_corrected = 0.0
    local N1_actual = 0.0
    local N1_corrected_raw_max_climb = 0.0
    local N1_corrected_mod_max_climb = 0.0
    local N1_real_max_climb = 0.0
    local N1_corrected_raw_max_cruise = 0.0
    local N1_corrected_mod_max_cruise = 0.0
    local N1_real_max_cruise = 0.0
    local climb_rate_fpm = 0
    local climb_angle_deg = 0.0

    local thrust_per_engine_N = 0.0
    local corrected_thrust_lbf = 0.0

    --Due to modeling differences / deficiencies, the climb rates below are tweaked (higher) to
    --allow for more closely matched real-world performance.  Ideal generic target climb rates are:
    --  >> 0 - 10000 ft = 2200fpm
    --  >> 10000 - 20000ft = 2100fpm
    --  >> 20000 - 30000ft = 1700fpm
    if simConfigData["data"].PLANE.engines == "CF6-80C2-B1F" then
      if simDR_altitude < 10000 then
        climb_rate_fpm = 2750
      elseif simDR_altitude <= 20000 then
        climb_rate_fpm = 2750
      elseif simDR_altitude <= 30000 then
        climb_rate_fpm = 2500
      elseif simDR_altitude <= 40000 then
        climb_rate_fpm = 2000
      elseif simDR_altitude <= 50000 then
        climb_rate_fpm = 1500
      end
    elseif simConfigData["data"].PLANE.engines == "CF6-80C2-B5F" or simConfigData["data"].PLANE.engines == "CF6-80C2-B1F1" then
      --For now, use the same climb rates as the B1F until we have specific information for B5F and others
      if simDR_altitude < 10000 then
        climb_rate_fpm = 2750
      elseif simDR_altitude <= 20000 then
        climb_rate_fpm = 2750
      elseif simDR_altitude <= 30000 then
        climb_rate_fpm = 2500
      elseif simDR_altitude <= 40000 then
        climb_rate_fpm = 2000
      elseif simDR_altitude <= 50000 then
        climb_rate_fpm = 1500
      end
  end

    --if B747DR_altitude_dial >= (altitude_ft_in - 250) and B747DR_ref_thr_limit_mode == "CRZ" then
    if fmc_alt >= (altitude_ft_in - 250) and B747DR_ref_thr_limit_mode == "CRZ" then
      climb_rate_fpm = 0
    end

    climb_angle_deg = math.asin(0.00508 * climb_rate_fpm / tas_mtrs_sec) * 180 / math.pi

    --get in_flight_thrust() data
    _, thrust_per_engine_N, _, corrected_thrust_lbf = in_flight_thrust(simDR_acf_weight_total_kg, climb_angle_deg)

    N1_corrected = (-1.4446E-12 * mach^2 + 1.2102E-12 * mach + 4.8911E-13) * corrected_thrust_lbf^3 + (1.1197E-07 * mach^2 - 7.8717E-08 * mach -6.498200000000001E-08)
                    * corrected_thrust_lbf^2 + (-0.0027 * mach^2 + 0.0011 * mach + 0.0036) * corrected_thrust_lbf + (36.93 * mach + 20.96)

    N1_actual = N1_corrected * math.sqrt(temperature_ratio)

    if delta_t_isa_K_in > 0 then
        if delta_t_isa_K_in > 10 then
            N1_corrected_raw_max_climb = -0.25 * delta_t_isa_K_in + 95.8 + (-5.8239E-09 * altitude_ft_in^2 + 0.00077693 * altitude_ft_in)
            N1_corrected_raw_max_cruise = -0.255 * delta_t_isa_K_in + 96 + (-7.5969E-09 * altitude_ft_in^2 + 0.00075761 * altitude_ft_in)
        else
            N1_corrected_raw_max_climb = -0.04 * delta_t_isa_K_in + 96 + (-5.8239E-09 * altitude_ft_in^2 + 0.00077693 * altitude_ft_in)
        end
    else
      N1_corrected_raw_max_climb = 96 + (-5.8239E-09 * altitude_ft_in^2 + 0.00077693 * altitude_ft_in)
      N1_corrected_raw_max_cruise = 93.5 + (-7.5969E-09 * altitude_ft_in^2 + 0.00075761 * altitude_ft_in)
    end
    
    if altitude_ft_in > 24000 then
      N1_corrected_mod_max_climb = N1_corrected_raw_max_climb -3.5722E-08 * altitude_ft_in^2 + 0.002463 * altitude_ft_in - 38.585
      N1_corrected_mod_max_cruise = N1_corrected_raw_max_cruise -3.5722E-08 * altitude_ft_in^2 + 0.002463 * altitude_ft_in - 38.585
    else
      N1_corrected_mod_max_climb = N1_corrected_raw_max_climb
      N1_corrected_mod_max_cruise = N1_corrected_raw_max_cruise
    end
  
    N1_real_max_climb = N1_corrected_mod_max_climb * math.sqrt(temperature_ratio_adapted)
    N1_real_max_cruise = N1_corrected_mod_max_cruise * math.sqrt(temperature_ratio_adapted)

    if enable_logging then
      print("\t\t\t\t\t<<<--- IN FLIGHT N1 (GE) --->>>")
      print("Altitude IN = ", altitude_ft_in)
      print("Delta T ISA IN = ", delta_t_isa_K_in)
      print("Temperature Ratio = ", temperature_ratio)
      print("Temperature Ratio Adapted = ", temperature_ratio_adapted)
      print("Mach = ", mach)
      print("Thrust per Engine N = ", thrust_per_engine_N)
      print("Corrected Thrust LBF = ", corrected_thrust_lbf)
      print("Climb Rate FPM = ", climb_rate_fpm)
      print("Climb Angle = ", climb_angle_deg)
      print("N1 Corrected Raw MAX Climb = ", N1_corrected_raw_max_climb)
      print("N1 Corrected MOD MAX Climb = ", N1_corrected_mod_max_climb)
      print("N1 Real MAX Climb = ", N1_real_max_climb)
      print("N1 Corrected Raw MAX Cruise = ", N1_corrected_raw_max_cruise)
      print("N1 Corrected MOD MAX Cruise = ", N1_corrected_mod_max_cruise)
      print("N1 Real MAX Cruise = ", N1_real_max_cruise)
      print("N1 Corrected = ", N1_corrected)
      print("N1 Actual = ", N1_actual)
    end

    return N1_corrected, N1_actual, N1_corrected_raw_max_climb, N1_corrected_mod_max_climb, N1_real_max_climb, N1_corrected_raw_max_cruise, N1_corrected_mod_max_cruise, N1_real_max_cruise
end

function N1_display_GE(altitude_ft_in, thrust_N_in, n1_factor_in, engine_in)
    local N1_corrected = 0.0
    local N1_actual = 0.0
    local corrected_thrust_N = 0.0
    local corrected_thrust_lbf = 0.0
    local actual_thrust_lbf = 0.0

    corrected_thrust_N = thrust_N_in / pressure_ratio
    corrected_thrust_lbf = corrected_thrust_N / lbf_to_N
    
    actual_thrust_lbf = corrected_thrust_lbf * pressure_ratio

    N1_corrected = (-1.4446E-12 * mach^2 + 1.2102E-12 * mach + 4.8911E-13) * corrected_thrust_lbf^3 + (1.1197E-07 * mach^2 - 7.8717E-08 * mach - 6.498200000000002E-08)
    * corrected_thrust_lbf^2 + (-0.0027 * mach^2 + 0.0011 * mach + 0.0036) * corrected_thrust_lbf + (36.93 * mach + 20.96)

    N1_actual = N1_corrected * math.sqrt(temperature_ratio)

    --Keep the N1 display steady during TO until we manage thrust
    if string.match(B747DR_ref_thr_limit_mode, "TO") or B747DR_ref_thr_limit_mode == "NONE" or B747DR_ref_thr_limit_mode == "" then
      N1_actual = simDR_N1[engine_in] * n1_factor_in
    end

    --Since thrust_n from XP can calculate to negative, don't let the displayed N1 go below 20% in flight
    if simDR_onGround ~= 1 and N1_actual < 20.0 then
      N1_actual = 20.0
    end

    if enable_logging then
      print("\t\t\t\t\t<<<--- N1 DISPLAY (GE) --->>>")
      print("Altitude IN = ", altitude_ft_in)
      print("Thrust IN = ", thrust_N_in)
      print("Pressure Ratio = ", pressure_ratio)
      print("Temperature K = ", temperature_K)
      print("Temperature Ratio = ", temperature_ratio)
      print("Mach = ", mach)
      print("Corrected Thrust LBF = ", corrected_thrust_lbf)
      print("Actual Thrust LBF = ", actual_thrust_lbf)
      print("N1 Actual = ", N1_actual)
    end

    return N1_actual
end

local takeoff_TOGA_n1 = 0.0

function GE(altitude_ft_in)
	local altitude = 0.0  --round_thrustcalc(simDR_altitude, "ALT")
	local temperature = 0
	local nbr_packs_on = 0  --B747DR_packs[0] + B747DR_packs[1] + B747DR_packs[2]
	local packs_adjustment_value = 0.0
	local engine_anti_ice_adjustment_value = 0.0
	local wing_anti_ice_adjustment_value = 0.0
	local takeoff_thrust_n1 = 1.0  --100.0
	local takeoff_thrust_n1_throttle = 0.00
  local N1_display = {}

  --In-flight variables
  local N1_actual = 0.0
  local N1_real_max_climb = 0.0
  local N1_real_max_cruise = 0.0

	--Setup engine factors based on engine type
	if simConfigData["data"].PLANE.engines == "CF6-80C2-B1F" then
    engine_max_thrust_n = 258000 
    simDR_engine_high_idle_ratio = 1.24  --More realistic idle
    simDR_throttle_max = 1.0
    simDR_thrust_max = 254260  --(57160 lbf)
	elseif simConfigData["data"].PLANE.engines == "CF6-80C2-B5F" then
    engine_max_thrust_n = 276000
    simDR_engine_high_idle_ratio = 1.24  --More realistic idle
    simDR_throttle_max = 1.0
    simDR_thrust_max = 267028  --(60030 lbf)
	elseif simConfigData["data"].PLANE.engines == "CF6-80C2-B1F1" then
    engine_max_thrust_n = 276000
    simDR_engine_high_idle_ratio = 1.24  --More realistic idle
    simDR_throttle_max = 1.0
    simDR_thrust_max = 267028  --(60030 lbf)
	end

  --Find current altitude rounded to the closest 1000 feet (for use in table lookups)
  altitude = round_thrustcalc(altitude_ft_in, "ALT")

	--Packs Adjustment
  nbr_packs_on = B747DR_packs[0] + B747DR_packs[1] + B747DR_packs[2]

	if nbr_packs_on == 0 then
		packs_adjustment_value = TOGA_N1_GE_adjustment["3PACKS_OFF"][altitude]
	elseif nbr_packs_on == 1 then
		packs_adjustment_value = TOGA_N1_GE_adjustment["2PACKS_OFF"][altitude]
	else
		packs_adjustment_value = 0.00
	end

	--Engine Anti-Ice Adjustment
	for i = 0, 3 do
		if simDR_engine_anti_ice[i] == 1 then
			engine_anti_ice_adjustment_value = TOGA_N1_GE_adjustment["NACELLE_AI_ON"][altitude]
		end
	end

	--print("Alt = "..altitude)
	--print("Temp = "..temperature)
	if simDR_onGround == 1 then
		--temperature = find_closest_temperature(TOGA_N1_GE, simDR_temperature)
		--airport_altitude = altitude
		--print("Closest Temp = ", temperature)
		--print("Takeoff Parameters = ", temperature, altitude, packs_adjustment_value, engine_anti_ice_adjustment_value)
		takeoff_thrust_n1, takeoff_thrust_n = take_off_N1_GE(altitude_ft_in)   --TOGA_N1_GE[temperature][altitude] + packs_adjustment_value + engine_anti_ice_adjustment_value
    
    if B747DR_toderate == 0 then
      takeoff_TOGA_n1 = takeoff_thrust_n1
    end

    takeoff_thrust_n1_throttle = B747_rescale(0.0, 0.0, tonumber(takeoff_TOGA_n1), 1.0, tonumber(takeoff_thrust_n1))
    
		-- Set N1 Target Bugs & Reference Indicator
		for i = 0, 3 do
			simDR_N1_target_bug[i] = string.format("%4.1f",takeoff_thrust_n1) + packs_adjustment_value + engine_anti_ice_adjustment_value
      B747DR_display_N1_ref[i] = string.format("%4.1f",takeoff_thrust_n1) + packs_adjustment_value + engine_anti_ice_adjustment_value
      B747DR_display_N1_max[i] = string.format("%4.1f",takeoff_thrust_n1) + packs_adjustment_value + engine_anti_ice_adjustment_value
      simDR_EPR_target_bug[i] = 0.0
		end

		B747DR_TO_throttle = takeoff_thrust_n1_throttle
  end

	if string.match(B747DR_ref_thr_limit_mode, "CLB") then
    _, N1_actual, _, _, N1_real_max_climb, _, _, _ = in_flight_N1_GE(altitude_ft_in, 0)

		--Set target bugs
		for i = 0, 3 do
				--if simDR_flap_ratio <= 0.34 then --and B747DR_radio_altitude > 1500 then
          if N1_actual > N1_real_max_climb and B747DR_radio_altitude > 5000 then
  				  simDR_N1_target_bug[i] = string.format("%4.1f", N1_real_max_climb) + packs_adjustment_value + engine_anti_ice_adjustment_value
            B747DR_display_N1_ref[i] = string.format("%4.1f", N1_real_max_climb) + packs_adjustment_value + engine_anti_ice_adjustment_value
          else
            simDR_N1_target_bug[i] = string.format("%4.1f", N1_actual) + packs_adjustment_value + engine_anti_ice_adjustment_value
            B747DR_display_N1_ref[i] = string.format("%4.1f", N1_actual) + packs_adjustment_value + engine_anti_ice_adjustment_value
          end
				--end

      simDR_EPR_target_bug[i] = 0.0

      B747DR_display_N1_max[i] = string.format("%4.1f", N1_real_max_climb) + packs_adjustment_value + engine_anti_ice_adjustment_value
    end
  elseif string.match(B747DR_ref_thr_limit_mode, "CRZ") then
      _, N1_actual, _, _, _, _, _, N1_real_max_cruise = in_flight_N1_GE(altitude_ft_in, 0)

      --Set target bugs
      for i = 0, 3 do
          simDR_N1_target_bug[i] = string.format("%4.1f", N1_real_max_cruise) + packs_adjustment_value + engine_anti_ice_adjustment_value
          B747DR_display_N1_ref[i] = string.format("%4.1f", N1_actual) + packs_adjustment_value + engine_anti_ice_adjustment_value
          B747DR_display_N1_max[i] = simDR_N1_target_bug[i] + packs_adjustment_value + engine_anti_ice_adjustment_value
      end
  elseif B747DR_ref_thr_limit_mode == "GA" then
    --Find current temperature rounded to the closest 5 degrees (for use in table lookups)
    --temperature = round_thrustcalc(simDR_temperature, "TEMP")

    --Find G/A N1 based on current temperature
    temperature = find_closest_temperature(TOGA_N1_GE, simDR_temperature)

    --Set G/A N1 targets
    for i = 0, 3 do
			simDR_N1_target_bug[i] = TOGA_N1_GE[temperature][altitude] + packs_adjustment_value + engine_anti_ice_adjustment_value
      B747DR_display_N1_max[i] = simDR_N1_target_bug[i]
		end
	end

	--Display calculated N1
  if takeoff_thrust_n1 == nil then
    takeoff_thrust_n1 = 100
  end

	for i = 0, 3 do
    --takeoff_TOGA_n1 (max TO) is used as a factor to compute N1 for TO based on the simDR_N1 to prevent N1 display loss during TO -- in flight it is calculated based on Newtons
    --N1_display[i] = string.format("%4.1f", N1_display_GE(altitude_ft_in, simDR_thrust_n[i], takeoff_TOGA_n1 / 100 * 1.007, i))  --use i as a reference for engine number
    N1_display[i] = string.format("%4.1f", N1_display_GE(altitude_ft_in, simDR_thrust_n[i], takeoff_TOGA_n1 / 100, i))  --use i as a reference for engine number
    --print("Takeoff TOGA = ", takeoff_TOGA_n1)
    --print("N1 Display[0] = ", N1_display[0])
    B747DR_display_N1[i] = tonumber(N1_display[i])
	end

  if enable_logging then
    print("Takeoff TOGA = ", takeoff_TOGA_n1)
  end
  --Manage Thrust
  throttle_management()
  thrust_ref_control_N1()
end