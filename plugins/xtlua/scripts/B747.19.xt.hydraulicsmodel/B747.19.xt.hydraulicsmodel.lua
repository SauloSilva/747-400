--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks
*****************************************************************************************
xt.hydraulicsmodel.lua
27/04/2020
]]
function deferred_command(name,desc,realFunc)
	return replace_command(name,realFunc)
end

function deferred_dataref(name,nilType,callFunction)
  if callFunction~=nil then
    print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end

B747DR_controlOverrides   = find_dataref("xtlua/controlObject")

B747DR_button_switch_position   = find_dataref("laminar/B747/button_switch/position")
simDR_ias_pilot				= find_dataref("laminar/B747/gauges/indicators/airspeed_kts_pilot")
B747DR_display_N1					= deferred_dataref("laminar/B747/engines/display_N1", "array[4]")
B747DR_display_N2					= deferred_dataref("laminar/B747/engines/display_N2", "array[4]")
B747_duct_pressure_L                = deferred_dataref("laminar/B747/air/duct_pressure_L", "number")
B747_duct_pressure_R                = deferred_dataref("laminar/B747/air/duct_pressure_R", "number")
--B747DR_engine1psi    = deferred_dataref("laminar/B747/air/engine1/bleed_air_psi", "number")
--B747DR_engine4psi    = deferred_dataref("laminar/B747/air/engine4/bleed_air_psi", "number")
simDR_startup_running           = find_dataref("sim/operation/prefs/startup_running")
B747DR_hyd_temp = find_dataref("sim/physics/earth_temp_c")
B747DR_hyd_sys_pressure_1      = deferred_dataref("laminar/B747/hydraulics/pressure_1", "number")
B747DR_hyd_sys_pressure_2      = deferred_dataref("laminar/B747/hydraulics/pressure_2", "number")
B747DR_hyd_sys_pressure_3      = deferred_dataref("laminar/B747/hydraulics/pressure_3", "number")
B747DR_hyd_sys_pressure_4      = deferred_dataref("laminar/B747/hydraulics/pressure_4", "number")
B747DR_hyd_sys_pressure_13      = deferred_dataref("laminar/B747/hydraulics/pressure_13", "number")
B747DR_hyd_sys_pressure_23      = deferred_dataref("laminar/B747/hydraulics/pressure_23", "number")
B747DR_hyd_sys_pressure_24      = deferred_dataref("laminar/B747/hydraulics/pressure_24", "number")
B747DR_hyd_sys_pressure_234      = deferred_dataref("laminar/B747/hydraulics/pressure_234", "number")
B747DR_hyd_sys_pressure_use_1      = deferred_dataref("laminar/B747/hydraulics/pressure_use_1", "number")
B747DR_hyd_sys_pressure_use_2      = deferred_dataref("laminar/B747/hydraulics/pressure_use_2", "number")
B747DR_hyd_sys_pressure_use_3      = deferred_dataref("laminar/B747/hydraulics/pressure_use_3", "number")
B747DR_hyd_sys_pressure_use_4      = deferred_dataref("laminar/B747/hydraulics/pressure_use_4", "number")

B747DR_hyd_sys_temp_1      = deferred_dataref("laminar/B747/hydraulics/temp_1", "number")
B747DR_hyd_sys_temp_2      = deferred_dataref("laminar/B747/hydraulics/temp_2", "number")
B747DR_hyd_sys_temp_3      = deferred_dataref("laminar/B747/hydraulics/temp_3", "number")
B747DR_hyd_sys_temp_4      = deferred_dataref("laminar/B747/hydraulics/temp_4", "number")

B747DR_hyd_sys_res_1      = deferred_dataref("laminar/B747/hydraulics/res_1", "number")
B747DR_hyd_sys_res_2      = deferred_dataref("laminar/B747/hydraulics/res_2", "number")
B747DR_hyd_sys_res_3      = deferred_dataref("laminar/B747/hydraulics/res_3", "number")
B747DR_hyd_sys_res_4      = deferred_dataref("laminar/B747/hydraulics/res_4", "number")

B747DR_hyd_sys_restotal_1      = deferred_dataref("laminar/B747/hydraulics/restotal_1", "number")
B747DR_hyd_sys_restotal_2      = deferred_dataref("laminar/B747/hydraulics/restotal_2", "number")
B747DR_hyd_sys_restotal_3      = deferred_dataref("laminar/B747/hydraulics/restotal_3", "number")
B747DR_hyd_sys_restotal_4      = deferred_dataref("laminar/B747/hydraulics/restotal_4", "number")

B747DR_hyd_dem_pressure_1      = deferred_dataref("laminar/B747/hydraulics/dem_pressure_1", "number")
B747DR_hyd_dem_pressure_2      = deferred_dataref("laminar/B747/hydraulics/dem_pressure_2", "number")
B747DR_hyd_dem_pressure_3      = deferred_dataref("laminar/B747/hydraulics/dem_pressure_3", "number")
B747DR_hyd_dem_pressure_4      = deferred_dataref("laminar/B747/hydraulics/dem_pressure_4", "number")

B747DR_hyd_edp_pressure_1      = deferred_dataref("laminar/B747/hydraulics/edp_pressure_1", "number")
B747DR_hyd_edp_pressure_2      = deferred_dataref("laminar/B747/hydraulics/edp_pressure_2", "number")
B747DR_hyd_edp_pressure_3      = deferred_dataref("laminar/B747/hydraulics/edp_pressure_3", "number")
B747DR_hyd_edp_pressure_4      = deferred_dataref("laminar/B747/hydraulics/edp_pressure_4", "number")
B747DR_hyd_aux_pressure      = deferred_dataref("laminar/B747/hydraulics/aux_pressure", "number")

B747DR_hyd_dem_mode_1      = deferred_dataref("laminar/B747/hydraulics/dem_mode_1", "number")--off auto on
B747DR_hyd_dem_mode_2      = deferred_dataref("laminar/B747/hydraulics/dem_mode_2", "number")
B747DR_hyd_dem_mode_3      = deferred_dataref("laminar/B747/hydraulics/dem_mode_3", "number")
B747DR_hyd_dem_mode_4      = deferred_dataref("laminar/B747/hydraulics/dem_mode_4", "number")-- -1 aux off auto on
-- CRT Displays/EICAS Lower/HYD/valve_on
B747DR_hyd_valve_1      = deferred_dataref("laminar/B747/hydraulics/valve_1", "number")
B747DR_hyd_valve_2      = deferred_dataref("laminar/B747/hydraulics/valve_2", "number")
B747DR_hyd_valve_3      = deferred_dataref("laminar/B747/hydraulics/valve_3", "number")
B747DR_hyd_valve_4      = deferred_dataref("laminar/B747/hydraulics/valve_4", "number")
simDR_hyd_press_1_2               = deferred_dataref("laminar/B747/hydraulics/indicators/hydraulic_pressure_1_2_4", "number")
simDR_parking_brake_ratio       = find_dataref("sim/cockpit2/controls/parking_brake_ratio")
--************ FLIGHT SURFACES **********

B747DR_rudder_lwr_pos   = deferred_dataref("laminar/B747/flt_ctrls/rudder_lwr_pos", "number")
B747DR_rudder_upr_pos   = deferred_dataref("laminar/B747/flt_ctrls/rudder_upr_pos", "number")
B747DR_rudder_ratio   = deferred_dataref("laminar/B747/flt_ctrls/rudder_ratio", "number")
B747_controls_lower_rudder           = deferred_dataref("laminar/B747/cablecontrols/lower_rudder", "number")
B747_controls_upper_rudder           = deferred_dataref("laminar/B747/cablecontrols/upper_rudder", "number")

B747_controls_left_outer_elevator           = deferred_dataref("laminar/B747/cablecontrols/left_outer_elevator", "number")
B747_controls_right_outer_elevator            = deferred_dataref("laminar/B747/cablecontrols/right_outer_elevator", "number")
B747_controls_left_inner_elevator           = deferred_dataref("laminar/B747/cablecontrols/left_inner_elevator", "number")
B747_controls_right_inner_elevator          = deferred_dataref("laminar/B747/cablecontrols/right_inner_elevator", "number")

simDR_rudder            = find_dataref("sim/flightmodel2/wing/rudder1_deg")
B747DR_l_elev_inner   = deferred_dataref("laminar/B747/flt_ctrls/l_elev_inner", "number")
B747DR_r_elev_inner   = deferred_dataref("laminar/B747/flt_ctrls/r_elev_inner", "number")
B747DR_l_elev_outer   = deferred_dataref("laminar/B747/flt_ctrls/l_elev_outer", "number")
B747DR_r_elev_outer   = deferred_dataref("laminar/B747/flt_ctrls/r_elev_outer", "number")
simDR_elevator            = find_dataref("sim/flightmodel2/wing/elevator1_deg")

B747_controls_left_outer_aileron           = deferred_dataref("laminar/B747/cablecontrols/left_outer_aileron", "number")
B747_controls_right_outer_aileron            = deferred_dataref("laminar/B747/cablecontrols/right_outer_aileron", "number")
B747_controls_left_inner_aileron           = deferred_dataref("laminar/B747/cablecontrols/left_inner_aileron", "number")
B747_controls_right_inner_aileron          = deferred_dataref("laminar/B747/cablecontrols/right_inner_aileron", "number")


simDR_left_aileron_inner = find_dataref("sim/flightmodel/controls/wing2l_ail1def")
simDR_right_aileron_inner = find_dataref("sim/flightmodel/controls/wing2r_ail1def")
simDR_left_aileron_outer = find_dataref("sim/flightmodel/controls/wing4l_ail2def")
simDR_right_aileron_outer = find_dataref("sim/flightmodel/controls/wing4r_ail2def")
B747DR_l_aileron_inner   = deferred_dataref("laminar/B747/flt_ctrls/l_aileron_inner", "number")
B747DR_r_aileron_inner   = deferred_dataref("laminar/B747/flt_ctrls/r_aileron_inner", "number")
B747DR_l_aileron_outer   = deferred_dataref("laminar/B747/flt_ctrls/l_aileron_outer", "number")
B747DR_r_aileron_outer   = deferred_dataref("laminar/B747/flt_ctrls/r_aileron_outer", "number")

B747DR_l_aileron_outer_lockout   = deferred_dataref("laminar/B747/flt_ctrls/left_outer_aileron_lockout", "number")
B747DR_r_aileron_outer_lockout   = deferred_dataref("laminar/B747/flt_ctrls/right_outer_aileron_lockout", "number")

B747DR_spoilers      = deferred_dataref("laminar/B747/flt_ctrls/spoilers", "array[13]") --0 unused
B747DR_outer_spoilers      = deferred_dataref("laminar/B747/flt_ctrls/outer_spoilers", "array[2]") --for stat display
B747DR_flaps      = deferred_dataref("laminar/B747/flt_ctrls/flaps", "array[5]") --0 unuse

B747DR_spoiler1 = deferred_dataref("laminar/B747/cablecontrols/spoiler1", "number")
B747DR_spoiler2 = deferred_dataref("laminar/B747/cablecontrols/spoiler2", "number")
B747DR_spoiler3 = deferred_dataref("laminar/B747/cablecontrols/spoiler3", "number")
B747DR_spoiler4 = deferred_dataref("laminar/B747/cablecontrols/spoiler4", "number")
B747DR_spoiler5 = deferred_dataref("laminar/B747/cablecontrols/spoiler5", "number")

B747DR_spoiler6 = deferred_dataref("laminar/B747/cablecontrols/spoiler6", "number")
B747DR_spoiler7 = deferred_dataref("laminar/B747/cablecontrols/spoiler7", "number")

B747DR_spoiler8 = deferred_dataref("laminar/B747/cablecontrols/spoiler8", "number")
B747DR_spoiler9 = deferred_dataref("laminar/B747/cablecontrols/spoiler9", "number")
B747DR_spoiler10 = deferred_dataref("laminar/B747/cablecontrols/spoiler10", "number")
B747DR_spoiler11 = deferred_dataref("laminar/B747/cablecontrols/spoiler11", "number")
B747DR_spoiler12 = deferred_dataref("laminar/B747/cablecontrols/spoiler12", "number")

B747DR_speedbrake1 = deferred_dataref("laminar/B747/cablecontrols/speedbrake34", "number")
B747DR_speedbrake2 = deferred_dataref("laminar/B747/cablecontrols/speedbrake58", "number")
B747DR_speedbrake3 = deferred_dataref("laminar/B747/cablecontrols/speedbrake67", "number")
B747DR_speedbrake4 = deferred_dataref("laminar/B747/cablecontrols/speedbrake12", "number")

simDR_spoiler12  = find_dataref("sim/flightmodel/controls/wing3l_spo1def")
simDR_spoiler34  = find_dataref("sim/flightmodel/controls/wing3l_spo2def")
simDR_spoiler5  = find_dataref("sim/flightmodel/controls/wing1l_spo1def")
simDR_spoiler67  = find_dataref("sim/flightmodel2/wing/speedbrake1_deg") -- array [0] left, [1] right
simDR_spoiler8  = find_dataref("sim/flightmodel/controls/wing1r_spo1def")
simDR_spoiler910  = find_dataref("sim/flightmodel/controls/wing3r_spo2def")
simDR_spoiler1112  = find_dataref("sim/flightmodel/controls/wing3r_spo1def")

--simDR_flap1  = find_dataref("sim/flightmodel2/wing/flap1_deg")-- inner array [0] left, [1] right
--simDR_flap2  = find_dataref("sim/flightmodel2/wing/flap2_deg")-- outer array [0] left, [1] right

B747DR_flap1 = deferred_dataref("laminar/B747/cablecontrols/flap1", "number")
B747DR_flap2 = deferred_dataref("laminar/B747/cablecontrols/flap2", "number")
B747DR_flap3 = deferred_dataref("laminar/B747/cablecontrols/flap3", "number")
B747DR_flap4 = deferred_dataref("laminar/B747/cablecontrols/flap4", "number")
simDR_flap_ratio			= find_dataref("sim/cockpit2/controls/flap_ratio")
simDR_innerslats_ratio  	= find_dataref("sim/flightmodel2/controls/slat1_deploy_ratio")
simDR_outerslats_ratio  	= find_dataref("sim/flightmodel2/controls/slat2_deploy_ratio")

simDR_flap1  = find_dataref("sim/flightmodel/controls/wing3l_fla2def")
simDR_flap2  = find_dataref("sim/flightmodel/controls/wing1l_fla1def")
simDR_flap3  = find_dataref("sim/flightmodel/controls/wing1r_fla1def")
simDR_flap4  = find_dataref("sim/flightmodel/controls/wing3r_fla2def")

simDR_override_control_surfaces       = find_dataref("sim/operation/override/override_control_surfaces")
simDR_override_steering               = find_dataref("sim/operation/override/override_wheel_steer")
--simDR_hyd_press_2               = find_dataref("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2")
B747DR_hyd_dmd_pmp_sel_pos      = deferred_dataref("laminar/B747/hydraulics/dmd_pump/sel_dial_pos", "array[4]")
function B747_animate_value(current_value, target, min, max, speed)

    local fps_factor = math.min(0.1, speed * SIM_PERIOD)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
       return min
    else
        return current_value + ((target - current_value) * fps_factor)
    end

end
----- RESCALE ---------------------------------------------------------------------------
function B747_rescale(in1, out1, in2, out2, x)

  if x < in1 then return out1 end
  if x > in2 then return out2 end
  return out1 + (out2 - out1) * (x - in1) / (in2 - in1)

end

dofile("B747.19.xt.hydraulics_override.lua")
function B747_engine_hyd_valves()
-- ENGINE #1
    if B747DR_button_switch_position[30] > 0.95 then
        B747DR_hyd_valve_1 = 1
    elseif B747DR_button_switch_position[30] < 0.05 then
        B747DR_hyd_valve_1  = 0
    end


    -- ENGINE #2
    if B747DR_button_switch_position[31] > 0.95 then
        B747DR_hyd_valve_2  = 1
    elseif B747DR_button_switch_position[31] < 0.05 then
        B747DR_hyd_valve_2  = 0
    end


    -- ENGINE #3
    if B747DR_button_switch_position[32] > 0.95 then
        B747DR_hyd_valve_3  = 1
    elseif B747DR_button_switch_position[32] < 0.05 then
        B747DR_hyd_valve_3  = 0
    end


    -- ENGINE #4
    if B747DR_button_switch_position[33] > 0.95 then
        B747DR_hyd_valve_4  = 1
    elseif B747DR_button_switch_position[33] < 0.05 then
        B747DR_hyd_valve_4  = 0
    end
end
function B747_engine_dem_modes()
  
  B747DR_hyd_dem_mode_1=B747DR_hyd_dmd_pmp_sel_pos[0]
  B747DR_hyd_dem_mode_2=B747DR_hyd_dmd_pmp_sel_pos[1]
  B747DR_hyd_dem_mode_3=B747DR_hyd_dmd_pmp_sel_pos[2]
  B747DR_hyd_dem_mode_4=B747DR_hyd_dmd_pmp_sel_pos[3]
  
end
function B747_edp_pressures()
    if B747DR_hyd_valve_1==1 then
      B747DR_hyd_edp_pressure_1=30*B747DR_display_N1[0]
    else
      B747DR_hyd_edp_pressure_1=0;
    end
    
    if B747DR_hyd_valve_2==1 then
      B747DR_hyd_edp_pressure_2=30*B747DR_display_N1[1]
    else
      B747DR_hyd_edp_pressure_2=0;
    end
    
    if B747DR_hyd_valve_3==1 then
      B747DR_hyd_edp_pressure_3=30*B747DR_display_N1[2]
    else
      B747DR_hyd_edp_pressure_3=0;
    end
    
    if B747DR_hyd_valve_4==1 then
      B747DR_hyd_edp_pressure_4=30*B747DR_display_N1[3]
    else
      B747DR_hyd_edp_pressure_4=0;
    end
end

function B747_dem_pressures()
  if B747DR_hyd_dem_mode_1>0 then 
    if B747DR_hyd_dem_mode_1==2 then
      B747DR_hyd_dem_pressure_1=B747_duct_pressure_L*175
    elseif B747DR_hyd_edp_pressure_1<2000 then
      B747DR_hyd_dem_pressure_1=B747_duct_pressure_L*175
    else
      B747DR_hyd_dem_pressure_1=0
    end
  else
     B747DR_hyd_dem_pressure_1=0  
  end
  
  
  if B747DR_hyd_dem_mode_2>0 then
    if B747DR_hyd_dem_mode_2==2 then
      B747DR_hyd_dem_pressure_2=3000
    elseif B747DR_hyd_edp_pressure_2<2000 then
      B747DR_hyd_dem_pressure_2=3000
    else
      B747DR_hyd_dem_pressure_2=0
    end
   else
     B747DR_hyd_dem_pressure_2=0 
  end
 
  if B747DR_hyd_dem_mode_3>0 then
    if B747DR_hyd_dem_mode_3==2 then
      B747DR_hyd_dem_pressure_3=3000
    elseif B747DR_hyd_edp_pressure_3<2000 then
      B747DR_hyd_dem_pressure_3=3000
    else
      B747DR_hyd_dem_pressure_3=0
    end
   else
     B747DR_hyd_dem_pressure_3=0
  end
  
  if B747DR_hyd_dem_mode_4>0 then
    if B747DR_hyd_dem_mode_4==2 then
      B747DR_hyd_dem_pressure_4=B747_duct_pressure_R*175
    elseif B747DR_hyd_edp_pressure_4<2000 then
      B747DR_hyd_dem_pressure_4=B747_duct_pressure_R*175
    else
      B747DR_hyd_dem_pressure_4=0
    end
    elseif B747DR_hyd_dem_mode_4<0 then
     B747DR_hyd_aux_pressure=2950
     B747DR_hyd_dem_pressure_4=0
    else
     B747DR_hyd_dem_pressure_4=0
     B747DR_hyd_aux_pressure=0
  end
  
end
function B747_system_pressures()
  --B747_animate_value(B747DR_hyd_sys_pressure_1,math.max(B747DR_hyd_dem_pressure_1,B747DR_hyd_edp_pressure_1),0,3000,1)
  B747DR_hyd_sys_pressure_use_1=B747_animate_value(B747DR_hyd_sys_pressure_use_1,((B747DR_hyd_dem_pressure_1/2+B747DR_hyd_edp_pressure_1)/10)-1,-10,30,1)--math.max(B747DR_hyd_dem_pressure_1,B747DR_hyd_edp_pressure_1)
  B747DR_hyd_sys_pressure_use_2=B747_animate_value(B747DR_hyd_sys_pressure_use_2,((B747DR_hyd_dem_pressure_2+B747DR_hyd_edp_pressure_2)/10)-1,-10,30,1)--math.max(B747DR_hyd_dem_pressure_2,B747DR_hyd_edp_pressure_2)
  B747DR_hyd_sys_pressure_use_3=B747_animate_value(B747DR_hyd_sys_pressure_use_3,((B747DR_hyd_dem_pressure_3+B747DR_hyd_edp_pressure_3)/10)-1,-10,30,1)--math.max(B747DR_hyd_dem_pressure_3,B747DR_hyd_edp_pressure_3)
  B747DR_hyd_sys_pressure_use_4=B747_animate_value(B747DR_hyd_sys_pressure_use_4,((B747DR_hyd_dem_pressure_4/2+B747DR_hyd_edp_pressure_4+B747DR_hyd_aux_pressure)/10)-1,-10,30,1)--math.max(B747DR_hyd_dem_pressure_4,B747DR_hyd_edp_pressure_4,B747DR_hyd_aux_pressure)
  
  --sys_pressure_use now contains how much pressure we can put into the system
  B747DR_hyd_sys_pressure_1=B747_animate_value(B747DR_hyd_sys_pressure_1,B747DR_hyd_sys_pressure_1+B747DR_hyd_sys_pressure_use_1,0,3300-math.random()*50,10)
  B747DR_hyd_sys_pressure_2=B747_animate_value(B747DR_hyd_sys_pressure_2,B747DR_hyd_sys_pressure_2+B747DR_hyd_sys_pressure_use_2,0,3300-math.random()*50,10)
  B747DR_hyd_sys_pressure_3=B747_animate_value(B747DR_hyd_sys_pressure_3,B747DR_hyd_sys_pressure_3+B747DR_hyd_sys_pressure_use_3,0,3300-math.random()*50,10)
  B747DR_hyd_sys_pressure_4=B747_animate_value(B747DR_hyd_sys_pressure_4,B747DR_hyd_sys_pressure_4+B747DR_hyd_sys_pressure_use_4,0,3300-math.random()*50,10)
  B747DR_hyd_sys_pressure_13=math.max(B747DR_hyd_sys_pressure_1,B747DR_hyd_sys_pressure_3) --12 remapped to 13
  B747DR_hyd_sys_pressure_23=math.max(B747DR_hyd_sys_pressure_2,B747DR_hyd_sys_pressure_3)
  B747DR_hyd_sys_pressure_24=math.max(B747DR_hyd_sys_pressure_2,B747DR_hyd_sys_pressure_4) 
  B747DR_hyd_sys_pressure_234=math.max(B747DR_hyd_sys_pressure_2,B747DR_hyd_sys_pressure_3,B747DR_hyd_sys_pressure_4)
  B747DR_hyd_sys_res_1=B747DR_hyd_sys_restotal_1-(B747DR_hyd_sys_pressure_1/3000)*0.1
  B747DR_hyd_sys_res_2=B747DR_hyd_sys_restotal_2-(B747DR_hyd_sys_pressure_2/3000)*0.1
  B747DR_hyd_sys_res_3=B747DR_hyd_sys_restotal_3-(B747DR_hyd_sys_pressure_3/3000)*0.1
  B747DR_hyd_sys_res_4=B747DR_hyd_sys_restotal_4-(B747DR_hyd_sys_pressure_4/3000)*0.1
  simDR_hyd_press_1_2 = math.max(simDR_hyd_press_1_2,B747DR_hyd_sys_pressure_1,B747DR_hyd_sys_pressure_2,B747DR_hyd_sys_pressure_4)

  B747DR_hyd_sys_temp_1=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_1)*20
  B747DR_hyd_sys_temp_2=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_2)*20
  B747DR_hyd_sys_temp_3=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_3)*20
  B747DR_hyd_sys_temp_4=B747DR_hyd_temp+(1-B747DR_hyd_sys_res_4)*20
end
--*************************************************************************************--
--**                          EVENT CALLBACKS                        **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end
function B747_set_hyd_model_ER()
  B747DR_hyd_sys_pressure_use_1=3100
  B747DR_hyd_sys_pressure_use_2=3100
  B747DR_hyd_sys_pressure_use_3=3100
  B747DR_hyd_sys_pressure_use_4=3100
  B747DR_hyd_sys_pressure_1=3100
  B747DR_hyd_sys_pressure_2=3100
  B747DR_hyd_sys_pressure_3=3100
  B747DR_hyd_sys_pressure_4=3100
end  
function flight_start() 

    --rudder
    B747DR_rudder_ratio=1.0
    B747DR_controlOverrides = '{"minin":-1,"maxin":1,"minout":-32,"maxout":32,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_heading_ratio","dstDref":"laminar/B747/cablecontrols/lower_rudder","scaledref":"laminar/B747/flt_ctrls/rudder_ratio"}';
    B747DR_controlOverrides = '{"minin":-1,"maxin":1,"minout":-32,"maxout":32,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_heading_ratio","dstDref":"laminar/B747/cablecontrols/upper_rudder","scaledref":"laminar/B747/flt_ctrls/rudder_ratio"}';

    B747DR_controlOverrides = '{"minin":-32,"maxin":32,"minout":-32,"maxout":32,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/rudder_lwr_pos","dstDref":"sim/flightmodel/controls/vstab2_rud1def"}';
    B747DR_controlOverrides = '{"minin":-32,"maxin":32,"minout":-32,"maxout":32,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/rudder_upr_pos","dstDref":"sim/flightmodel/controls/vstab2_rud2def"}';
  
    --elevators
    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-17,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/left_outer_elevator"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":22,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/left_outer_elevator"}';

    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-17,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/right_outer_elevator"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":22,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/right_outer_elevator"}';

    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-17,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/left_inner_elevator"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":22,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/left_inner_elevator"}';

    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-17,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/right_inner_elevator"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":22,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_pitch_ratio","dstDref":"laminar/B747/cablecontrols/right_inner_elevator"}';

    B747DR_controlOverrides = '{"minin":-22,"maxin":17,"minout":-22,"maxout":17,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/l_elev_outer","dstDref":"sim/flightmodel/controls/hstab1_elv1def"}'; --left_outer_elevator
    B747DR_controlOverrides = '{"minin":-22,"maxin":17,"minout":-22,"maxout":17,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/r_elev_outer","dstDref":"sim/flightmodel/controls/hstab2_elv1def"}'; --right_outer_elevator
    B747DR_controlOverrides = '{"minin":-22,"maxin":17,"minout":-22,"maxout":17,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/l_elev_inner","dstDref":"sim/flightmodel/controls/hstab1_elv2def"}'; --left_inner_elevator
    B747DR_controlOverrides = '{"minin":-22,"maxin":17,"minout":-22,"maxout":17,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/r_elev_inner","dstDref":"sim/flightmodel/controls/hstab2_elv2def"}'; --right_inner_elevator
    
    --ailerons
    B747DR_controlOverrides = '{"minin":-1,"maxin":1,"minout":-20,"maxout":20,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/left_inner_aileron"}';
    B747DR_controlOverrides = '{"minin":-1,"maxin":1,"minout":-20,"maxout":20,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/right_inner_aileron"}';

    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-25,"maxout":0,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/left_outer_aileron","scaledref":"laminar/B747/flt_ctrls/left_outer_aileron_lockout"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":15,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/left_outer_aileron","scaledref":"laminar/B747/flt_ctrls/left_outer_aileron_lockout"}';

    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-15,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/right_outer_aileron","scaledref":"laminar/B747/flt_ctrls/right_outer_aileron_lockout"}';  
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":25,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/right_outer_aileron","scaledref":"laminar/B747/flt_ctrls/right_outer_aileron_lockout"}'; 
    
    B747DR_controlOverrides = '{"minin":-20,"maxin":20,"minout":-20,"maxout":20,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/l_aileron_inner","dstDref":"sim/flightmodel/controls/wing2l_ail1def"}';
    B747DR_controlOverrides = '{"minin":-20,"maxin":20,"minout":-20,"maxout":20,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/r_aileron_inner","dstDref":"sim/flightmodel/controls/wing2r_ail1def"}';
    B747DR_controlOverrides = '{"minin":-25,"maxin":15,"minout":-25,"maxout":15,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/l_aileron_outer","dstDref":"sim/flightmodel/controls/wing4l_ail2def"}';
    B747DR_controlOverrides = '{"minin":-15,"maxin":25,"minout":-15,"maxout":25,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/r_aileron_outer","dstDref":"sim/flightmodel/controls/wing4r_ail2def"}';  
    
    --spoilers
    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-45,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler1"}';
    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-45,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler2"}';
    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-45,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler3"}';
    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-45,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler4"}';  
    B747DR_controlOverrides = '{"minin":-1,"maxin":0,"minout":-20,"maxout":0,"scale":-1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler5"}';
   
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":20,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler8"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":45,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler9"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":45,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler10"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":45,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler11"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":1,"minout":0,"maxout":45,"scale":1.0,"srcDref":"sim/cockpit2/controls/total_roll_ratio","dstDref":"laminar/B747/cablecontrols/spoiler12"}';  
    
  
    --flaps
    B747DR_controlOverrides = '{"minin":0.167,"maxin":0.5,"minout":0,"maxout":10,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap1"}';
    B747DR_controlOverrides = '{"minin":0.167,"maxin":0.5,"minout":0,"maxout":10,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap2"}';
    B747DR_controlOverrides = '{"minin":0.167,"maxin":0.5,"minout":0,"maxout":10,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap3"}';
    B747DR_controlOverrides = '{"minin":0.167,"maxin":0.5,"minout":0,"maxout":10,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap4"}';  

    B747DR_controlOverrides = '{"minin":0.5,"maxin":1,"minout":0,"maxout":40,"scale":0.5,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap1"}';
    B747DR_controlOverrides = '{"minin":0.5,"maxin":1,"minout":0,"maxout":40,"scale":0.5,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap2"}';
    B747DR_controlOverrides = '{"minin":0.5,"maxin":1,"minout":0,"maxout":40,"scale":0.5,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap3"}';
    B747DR_controlOverrides = '{"minin":0.5,"maxin":1,"minout":0,"maxout":40,"scale":0.5,"srcDref":"laminar/B747/cablecontrols/flap_ratio","dstDref":"laminar/B747/cablecontrols/flap4"}';  
    --flap display
    --flap 1 
    B747DR_controlOverrides = '{"minin":0,"maxin":0.167,"minout":0,"maxout":0.167,"scale":1.0,"srcDref":"sim/cockpit2/controls/flap_ratio","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio1"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":10,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing3l_fla2def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio1"}';
    B747DR_controlOverrides = '{"minin":10,"maxin":17,"minout":0,"maxout":0.167,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing3l_fla2def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio1"}';
    B747DR_controlOverrides = '{"minin":17,"maxin":30,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing3l_fla2def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio1"}';
    
    --flap 2 
    B747DR_controlOverrides = '{"minin":0,"maxin":0.167,"minout":0,"maxout":0.167,"scale":1.0,"srcDref":"sim/cockpit2/controls/flap_ratio","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio2"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":10,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing1l_fla1def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio2"}';
    B747DR_controlOverrides = '{"minin":10,"maxin":17,"minout":0,"maxout":0.167,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing1l_fla1def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio2"}';
    B747DR_controlOverrides = '{"minin":17,"maxin":30,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing1l_fla1def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio2"}';

    --flap 3 
    B747DR_controlOverrides = '{"minin":0,"maxin":0.167,"minout":0,"maxout":0.167,"scale":1.0,"srcDref":"sim/cockpit2/controls/flap_ratio","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio3"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":10,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing1r_fla1def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio3"}';
    B747DR_controlOverrides = '{"minin":10,"maxin":17,"minout":0,"maxout":0.167,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing1r_fla1def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio3"}';
    B747DR_controlOverrides = '{"minin":17,"maxin":30,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing1r_fla1def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio3"}';

    --flap 4 
    B747DR_controlOverrides = '{"minin":0,"maxin":0.167,"minout":0,"maxout":0.167,"scale":1.0,"srcDref":"sim/cockpit2/controls/flap_ratio","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio4"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":10,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing3r_fla2def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio4"}';
    B747DR_controlOverrides = '{"minin":10,"maxin":17,"minout":0,"maxout":0.167,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing3r_fla2def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio4"}';
    B747DR_controlOverrides = '{"minin":17,"maxin":30,"minout":0,"maxout":0.333,"scale":1.0,"max":1,"srcDref":"sim/flightmodel/controls/wing3r_fla2def","dstDref":"laminar/B747/gauges/indicators/flap_deployed_ratio4"}';

    --speedbrakes
    B747DR_controlOverrides = '{"minin":0.125,"maxin":0.53,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/speedbrake_lever","dstDref":"laminar/B747/cablecontrols/speedbrake34"}';
    B747DR_controlOverrides = '{"minin":0.125,"maxin":0.53,"minout":0,"maxout":20,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/speedbrake_lever","dstDref":"laminar/B747/cablecontrols/speedbrake58"}';
    B747DR_controlOverrides = '{"minin":0.40,"maxin":0.41,"minout":0,"maxout":20,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/speedbrake_lever","dstDref":"laminar/B747/cablecontrols/speedbrake67"}';
    B747DR_controlOverrides = '{"minin":0.65,"maxin":0.66,"minout":0,"maxout":50,"scale":0.5,"srcDref":"laminar/B747/flt_ctrls/speedbrake_lever","dstDref":"laminar/B747/cablecontrols/speedbrake67"}';
    B747DR_controlOverrides = '{"minin":0.6,"maxin":0.90,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/flt_ctrls/speedbrake_lever","dstDref":"laminar/B747/cablecontrols/speedbrake12"}';
    
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake12","dstDref":"laminar/B747/cablecontrols/spoiler1"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake12","dstDref":"laminar/B747/cablecontrols/spoiler2"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake34","dstDref":"laminar/B747/cablecontrols/spoiler3"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake34","dstDref":"laminar/B747/cablecontrols/spoiler4"}';  
    B747DR_controlOverrides = '{"minin":0,"maxin":20,"minout":0,"maxout":20,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake58","dstDref":"laminar/B747/cablecontrols/spoiler5"}';
   
    B747DR_controlOverrides = '{"minin":0,"maxin":20,"minout":0,"maxout":20,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake58","dstDref":"laminar/B747/cablecontrols/spoiler8"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake34","dstDref":"laminar/B747/cablecontrols/spoiler9"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake34","dstDref":"laminar/B747/cablecontrols/spoiler10"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake12","dstDref":"laminar/B747/cablecontrols/spoiler11"}';
    B747DR_controlOverrides = '{"minin":0,"maxin":45,"minout":0,"maxout":45,"scale":1.0,"srcDref":"laminar/B747/cablecontrols/speedbrake12","dstDref":"laminar/B747/cablecontrols/spoiler12"}';  

    B747DR_controlOverrides = '{"minin":20,"maxin":45,"minout":0,"maxout":50,"scale":0.5,"srcDref":"laminar/B747/cablecontrols/speedbrake67","dstDref":"laminar/B747/cablecontrols/spoiler5"}';
    B747DR_controlOverrides = '{"minin":20,"maxin":45,"minout":0,"maxout":50,"scale":0.5,"srcDref":"laminar/B747/cablecontrols/speedbrake67","dstDref":"laminar/B747/cablecontrols/spoiler8"}';

    B747DR_hyd_sys_restotal_1=math.random()*0.2+0.8
    B747DR_hyd_sys_restotal_2=math.random()*0.2+0.8
    B747DR_hyd_sys_restotal_3=math.random()*0.2+0.8
    B747DR_hyd_sys_restotal_4=math.random()*0.2+0.8
    B747DR_hyd_sys_res_1=B747DR_hyd_sys_restotal_1
    B747DR_hyd_sys_res_2=B747DR_hyd_sys_restotal_2
    B747DR_hyd_sys_res_3=B747DR_hyd_sys_restotal_3
    B747DR_hyd_sys_res_4=B747DR_hyd_sys_restotal_4

    B747DR_hyd_sys_temp_1=B747DR_hyd_temp
    B747DR_hyd_sys_temp_2=B747DR_hyd_temp
    B747DR_hyd_sys_temp_3=B747DR_hyd_temp
    B747DR_hyd_sys_temp_4=B747DR_hyd_temp
    if simDR_startup_running == 1 then

		B747_set_hyd_model_ER() -- pressurise the system if engines start running

    end
end

--function flight_crash() end

--function before_physics() end
debug_hydro     = deferred_dataref("laminar/B747/debug/hydro", "number")
function after_physics()
  if debug_hydro>0 then return end
   B747_engine_hyd_valves()
   B747_engine_dem_modes()
   B747_edp_pressures()
   B747_dem_pressures()
   B747_system_pressures()
   --consumers
   pressure_input()
   brake_accumulator()
   flight_controls_consumption()
   pressure_output()
   flight_controls_override()
end

--function after_replay() end